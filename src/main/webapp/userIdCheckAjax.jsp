<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	// 회원 가입시 사용
	Logger logger = LogManager.getLogger("userIdCheckAjax.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String regId = HttpUtil.get(request, "regId");
	
	if(!StringUtil.isEmpty(regId)){
		UserDao userDao = new UserDao();
		
		if(userDao.userSelectCount(regId) <= 0)	{
			response.getWriter().write("{\"flag\":0}");
		}
		else{
			response.getWriter().write("{\"flag\":1}");
		}
	}
	else{
		response.getWriter().write("{\"flag\":-1}");
	}
%>



