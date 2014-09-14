package com.taobao.tddl.repo.mysql.spi;

import java.util.Map;

import com.taobao.tddl.common.exception.TddlException;
import com.taobao.tddl.common.exception.TddlNestableRuntimeException;
import com.taobao.tddl.common.model.Group;
import com.taobao.tddl.common.utils.extension.Activate;
import com.taobao.tddl.executor.spi.IRepository;
import com.taobao.tddl.executor.spi.IRepositoryFactory;

@Activate(name = "MYSQL_JDBC")
public class RepositoryFactoryMyImp implements IRepositoryFactory {

    @Override
    public IRepository buildRepository(Group group, Map repoProperties, Map connectionProperties) {
        My_Repository myRepo = new My_Repository();
        try {
            myRepo.init();
        } catch (TddlException e) {
            throw new TddlNestableRuntimeException(e);
        }
        return myRepo;
    }

}
