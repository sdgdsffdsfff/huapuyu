package com.anders.vote.dao.impl;import org.junit.Test;import org.junit.runner.RunWith;import org.springframework.beans.factory.annotation.Autowired;import org.springframework.test.annotation.Rollback;import org.springframework.test.context.ContextConfiguration;import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;import org.springframework.transaction.annotation.Transactional;import com.anders.vote.dao.UrlDao;@RunWith(SpringJUnit4ClassRunner.class)// @ContextConfiguration(locations = { "classpath:spring.xml",// "classpath:spring-test.xml" })@ContextConfiguration(locations = "classpath:applicationContext.xml")public class UrlDaoTest {	@Autowired	private UrlDao urlDao;	@Test	@Transactional	@Rollback(false)	public void testGetAllFetchRoles() {		urlDao.getAllFetchRoles();	}}