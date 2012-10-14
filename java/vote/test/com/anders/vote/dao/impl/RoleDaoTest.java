package com.anders.vote.dao.impl;import java.util.Set;import org.junit.Test;import org.junit.runner.RunWith;import org.unitils.UnitilsJUnit4;import org.unitils.UnitilsJUnit4TestClassRunner;import org.unitils.dbunit.annotation.DataSet;import org.unitils.dbunit.datasetloadstrategy.impl.CleanInsertLoadStrategy;import org.unitils.spring.annotation.SpringApplicationContext;import org.unitils.spring.annotation.SpringBean;import com.anders.vote.dao.RoleDao;@RunWith(UnitilsJUnit4TestClassRunner.class)@SpringApplicationContext("classpath:applicationContext-test.xml")@DataSet(loadStrategy = CleanInsertLoadStrategy.class)public class RoleDaoTest extends UnitilsJUnit4 {	@SpringBean(value = "roleDao")	private RoleDao roleDao;	@Test	@DataSet("RoleDaoTest.xml")	public void testGetRolesByUserName() {		Set<String> roleSet = roleDao.getRolesByUserName("admini");		for (String role : roleSet) {			System.out.println(role);		}	}}