package com.alibaba.cobar.manager.web.screen;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

/**
 * @author haiqing.zhuhq 2011-6-27
 */
public class AddUserPage extends AbstractController implements InitializingBean {

    @Override
    public void afterPropertiesSet() throws Exception {
    }

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
                                                                                                          throws Exception {
        return new ModelAndView("m_addUser", null);
    }
}
