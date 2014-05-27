/*
 *    Copyright 2010-2013 the original author or authors.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
package com.vipshop.mybatis;

import static com.vipshop.mybatis.SqlSessionUtils.closeSqlSession;
import static com.vipshop.mybatis.SqlSessionUtils.getSqlSession;
import static com.vipshop.mybatis.SqlSessionUtils.isSqlSessionTransactional;
import static java.lang.reflect.Proxy.newProxyInstance;
import static org.apache.ibatis.reflection.ExceptionUtil.unwrapThrowable;
import static org.springframework.util.Assert.notNull;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.executor.BatchResult;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.dao.support.PersistenceExceptionTranslator;

import com.vipshop.mybatis.annotation.Shard;
import com.vipshop.mybatis.bo.User;
import com.vipshop.mybatis.common.ShardParam;
import com.vipshop.mybatis.common.SqlSessionFactoryHolder;
import com.vipshop.mybatis.common.StrategyHolder;
import com.vipshop.mybatis.strategy.NoShardStrategy;
import com.vipshop.mybatis.strategy.ShardStrategy;

/**
 * Thread safe, Spring managed, {@code SqlSession} that works with Spring
 * transaction management to ensure that that the actual SqlSession used is the
 * one associated with the current Spring transaction. In addition, it manages
 * the session life-cycle, including closing, committing or rolling back the
 * session as necessary based on the Spring transaction configuration.
 * <p>
 * The template needs a SqlSessionFactory to create SqlSessions, passed as a
 * constructor argument. It also can be constructed indicating the executor type
 * to be used, if not, the default executor type, defined in the session factory
 * will be used.
 * <p>
 * This template converts MyBatis PersistenceExceptions into unchecked
 * DataAccessExceptions, using, by default, a {@code MyBatisExceptionTranslator}.
 * <p>
 * Because SqlSessionTemplate is thread safe, a single instance can be shared
 * by all DAOs; there should also be a small memory savings by doing this. This
 * pattern can be used in Spring configuration files as follows:
 *
 * <pre class="code">
 * {@code
 * <bean id="sqlSessionTemplate" class="org.mybatis.spring.SqlSessionTemplate">
 *   <constructor-arg ref="sqlSessionFactory" />
 * </bean>
 * }
 * </pre>
 *
 * @author Putthibong Boonbong
 * @author Hunter Presnall
 * @author Eduardo Macarron
 * 
 * @see SqlSessionFactory
 * @see MyBatisExceptionTranslator
 * @version $Id$
 */
public class SqlSessionTemplate implements SqlSession {

  private final SqlSessionFactory sqlSessionFactory;

  private final ExecutorType executorType;

  private final SqlSession sqlSessionProxy;

  private final PersistenceExceptionTranslator exceptionTranslator;

  /**
   * Constructs a Spring managed SqlSession with the {@code SqlSessionFactory}
   * provided as an argument.
   *
   * @param sqlSessionFactory
   */
  public SqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
    this(sqlSessionFactory, sqlSessionFactory.getConfiguration().getDefaultExecutorType());
  }

  /**
   * Constructs a Spring managed SqlSession with the {@code SqlSessionFactory}
   * provided as an argument and the given {@code ExecutorType}
   * {@code ExecutorType} cannot be changed once the {@code SqlSessionTemplate}
   * is constructed.
   *
   * @param sqlSessionFactory
   * @param executorType
   */
  public SqlSessionTemplate(SqlSessionFactory sqlSessionFactory, ExecutorType executorType) {
    this(sqlSessionFactory, executorType,
        new MyBatisExceptionTranslator(
            sqlSessionFactory.getConfiguration().getEnvironment().getDataSource(), true));
  }

  /**
   * Constructs a Spring managed {@code SqlSession} with the given
   * {@code SqlSessionFactory} and {@code ExecutorType}.
   * A custom {@code SQLExceptionTranslator} can be provided as an
   * argument so any {@code PersistenceException} thrown by MyBatis
   * can be custom translated to a {@code RuntimeException}
   * The {@code SQLExceptionTranslator} can also be null and thus no
   * exception translation will be done and MyBatis exceptions will be
   * thrown
   *
   * @param sqlSessionFactory
   * @param executorType
   * @param exceptionTranslator
   */
  public SqlSessionTemplate(SqlSessionFactory sqlSessionFactory, ExecutorType executorType,
      PersistenceExceptionTranslator exceptionTranslator) {

    notNull(sqlSessionFactory, "Property 'sqlSessionFactory' is required");
    notNull(executorType, "Property 'executorType' is required");
    
    this.sqlSessionFactory = sqlSessionFactory;
    this.executorType = executorType;
    this.exceptionTranslator = exceptionTranslator;
    this.sqlSessionProxy = (SqlSession) newProxyInstance(
        SqlSessionFactory.class.getClassLoader(),
        new Class[] { SqlSession.class },
        new SqlSessionInterceptor());
  }

  public SqlSessionFactory getSqlSessionFactory() {
    return this.sqlSessionFactory;
  }

  public ExecutorType getExecutorType() {
    return this.executorType;
  }

  public PersistenceExceptionTranslator getPersistenceExceptionTranslator() {
    return this.exceptionTranslator;
  }

  /**
   * {@inheritDoc}
   */
  public <T> T selectOne(String statement) {
    return this.sqlSessionProxy.<T> selectOne(statement);
  }

  /**
   * {@inheritDoc}
   */
  public <T> T selectOne(String statement, Object parameter) {
    return this.sqlSessionProxy.<T> selectOne(statement, parameter);
  }

  /**
   * {@inheritDoc}
   */
  public <K, V> Map<K, V> selectMap(String statement, String mapKey) {
    return this.sqlSessionProxy.<K, V> selectMap(statement, mapKey);
  }

  /**
   * {@inheritDoc}
   */
  public <K, V> Map<K, V> selectMap(String statement, Object parameter, String mapKey) {
    return this.sqlSessionProxy.<K, V> selectMap(statement, parameter, mapKey);
  }

  /**
   * {@inheritDoc}
   */
  public <K, V> Map<K, V> selectMap(String statement, Object parameter, String mapKey, RowBounds rowBounds) {
    return this.sqlSessionProxy.<K, V> selectMap(statement, parameter, mapKey, rowBounds);
  }

  /**
   * {@inheritDoc}
   */
  public <E> List<E> selectList(String statement) {
    return this.sqlSessionProxy.<E> selectList(statement);
  }

  /**
   * {@inheritDoc}
   */
  public <E> List<E> selectList(String statement, Object parameter) {
    return this.sqlSessionProxy.<E> selectList(statement, parameter);
  }

  /**
   * {@inheritDoc}
   */
  public <E> List<E> selectList(String statement, Object parameter, RowBounds rowBounds) {
    return this.sqlSessionProxy.<E> selectList(statement, parameter, rowBounds);
  }

  /**
   * {@inheritDoc}
   */
  public void select(String statement, ResultHandler handler) {
    this.sqlSessionProxy.select(statement, handler);
  }

  /**
   * {@inheritDoc}
   */
  public void select(String statement, Object parameter, ResultHandler handler) {
    this.sqlSessionProxy.select(statement, parameter, handler);
  }

  /**
   * {@inheritDoc}
   */
  public void select(String statement, Object parameter, RowBounds rowBounds, ResultHandler handler) {
    this.sqlSessionProxy.select(statement, parameter, rowBounds, handler);
  }

  /**
   * {@inheritDoc}
   */
  public int insert(String statement) {
    return this.sqlSessionProxy.insert(statement);
  }

  /**
   * {@inheritDoc}
   */
  public int insert(String statement, Object parameter) {
    return this.sqlSessionProxy.insert(statement, parameter);
  }

  /**
   * {@inheritDoc}
   */
  public int update(String statement) {
    return this.sqlSessionProxy.update(statement);
  }

  /**
   * {@inheritDoc}
   */
  public int update(String statement, Object parameter) {
    return this.sqlSessionProxy.update(statement, parameter);
  }

  /**
   * {@inheritDoc}
   */
  public int delete(String statement) {
    return this.sqlSessionProxy.delete(statement);
  }

  /**
   * {@inheritDoc}
   */
  public int delete(String statement, Object parameter) {
    return this.sqlSessionProxy.delete(statement, parameter);
  }

  /**
   * {@inheritDoc}
   */
  public <T> T getMapper(Class<T> type) {
    return getConfiguration().getMapper(type, this);
  }

  /**
   * {@inheritDoc}
   */
  public void commit() {
    throw new UnsupportedOperationException("Manual commit is not allowed over a Spring managed SqlSession");
  }

  /**
   * {@inheritDoc}
   */
  public void commit(boolean force) {
    throw new UnsupportedOperationException("Manual commit is not allowed over a Spring managed SqlSession");
  }

  /**
   * {@inheritDoc}
   */
  public void rollback() {
    throw new UnsupportedOperationException("Manual rollback is not allowed over a Spring managed SqlSession");
  }

  /**
   * {@inheritDoc}
   */
  public void rollback(boolean force) {
    throw new UnsupportedOperationException("Manual rollback is not allowed over a Spring managed SqlSession");
  }

  /**
   * {@inheritDoc}
   */
  public void close() {
    throw new UnsupportedOperationException("Manual close is not allowed over a Spring managed SqlSession");
  }

  /**
   * {@inheritDoc}
   */
  public void clearCache() {
    this.sqlSessionProxy.clearCache();
  }

  /**
   * {@inheritDoc}
   *
   */
  public Configuration getConfiguration() {
    return this.sqlSessionFactory.getConfiguration();
  }

  /**
   * {@inheritDoc}
   */
  public Connection getConnection() {
    return this.sqlSessionProxy.getConnection();
  }

  /**
   * {@inheritDoc}
   *
   * @since 1.0.2
   *
   */
  public List<BatchResult> flushStatements() {
    return this.sqlSessionProxy.flushStatements();
  }

  /**
   * Proxy needed to route MyBatis method calls to the proper SqlSession got
   * from Spring's Transaction Manager
   * It also unwraps exceptions thrown by {@code Method#invoke(Object, Object...)} to
   * pass a {@code PersistenceException} to the {@code PersistenceExceptionTranslator}.
   */
  private class SqlSessionInterceptor implements InvocationHandler {
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
    	
			String fullName = String.valueOf(args[0]);
			String className = fullName.substring(0, fullName.lastIndexOf("."));
			String methodName = fullName.substring(fullName.lastIndexOf(".") + 1, fullName.length());

			Class clazz = Class.forName(className);
			Method meth = clazz.getMethod(methodName, args[1].getClass());

			String shardField = null;
			String shardName = null;

			Shard shard = meth.getAnnotation(Shard.class);
			if (shard == null) {
				throw new RuntimeException("没有配置分片参数");
			}

			shardField = shard.field();
			shardName = shard.name();

			Object shardFieldValue = BeanUtils.getProperty(args[1], shardField);
			ShardParam shardParam = new ShardParam();
			shardParam.setName(shardName);
			shardParam.setShardValue(shardFieldValue);
			shardParam.setParams(args[1]);
    	
    	
			ShardStrategy shardStrategy = SqlSessionFactoryHolder.getStrategyName2ShardStrategy().get(shardName);
			if (shardStrategy == null) {
				shardStrategy = NoShardStrategy.INSTANCE;
			}
			
			
			
    	User user = (User) args[1];
    	String dataSourceId = null;
    	if (user.getId() > 100 && user.getId() <= 200) {
    		dataSourceId = "dataSource_mysql_1";
    	}
    	else if (user.getId() > 200 && user.getId() <= 300) {
    		dataSourceId = "dataSource_mysql_2";
    	} else {
    		dataSourceId = "dataSource";
    	}
    	
    	SqlSession sqlSession = getSqlSession(
     	          SqlSessionFactoryHolder.getDataSourceId2SqlSessionFactory().get(dataSourceId),
     	          SqlSessionTemplate.this.executorType,
     	          SqlSessionTemplate.this.exceptionTranslator);
    	
    	Configuration configuration = SqlSessionFactoryHolder.getDataSourceId2SqlSessionFactory().get(dataSourceId).getConfiguration();
		MappedStatement mappedStatement = configuration.getMappedStatement(String.valueOf(args[0]));
		BoundSql boundSql = mappedStatement.getBoundSql(shardParam.getParams());
		
    	shardStrategy.setDataSource(configuration.getEnvironment().getDataSource());
		shardStrategy.setShardParam(shardParam);
		shardStrategy.setSql(boundSql.getSql());
		
		StrategyHolder.setShardStrategy(shardStrategy);
      
//      if (ArrayUtils.isNotEmpty(args)) {
//    	  ShardParam shardParam = new ShardParam(String.valueOf(args[0]), ((User)args[1]).getId(), args[1]);
//    	  args[1] = shardParam;
//      }
      
      try {
        Object result = method.invoke(sqlSession, args);
        if (!isSqlSessionTransactional(sqlSession, SqlSessionTemplate.this.sqlSessionFactory)) {
          // force commit even on non-dirty sessions because some databases require
          // a commit/rollback before calling close()
          sqlSession.commit(true);
        }
        
        return result;
      } catch (Throwable t) {
        Throwable unwrapped = unwrapThrowable(t);
        if (SqlSessionTemplate.this.exceptionTranslator != null && unwrapped instanceof PersistenceException) {
          // release the connection to avoid a deadlock if the translator is no loaded. See issue #22
          closeSqlSession(sqlSession, SqlSessionTemplate.this.sqlSessionFactory);
          sqlSession = null;
          Throwable translated = SqlSessionTemplate.this.exceptionTranslator.translateExceptionIfPossible((PersistenceException) unwrapped);
          if (translated != null) {
            unwrapped = translated;
          }
        }
        throw unwrapped;
      } finally {
        if (sqlSession != null) {
          closeSqlSession(sqlSession, SqlSessionTemplate.this.sqlSessionFactory);
        }
      }
    }
  }

}
