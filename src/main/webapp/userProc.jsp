<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	// 회원가입 + 회원정보수정
	Logger logger = LogManager.getLogger("userProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	logger.debug("11111");
	
	String msg = "";
	String redirectUrl = "";
	
	String regId = HttpUtil.get(request, "regId");
	String password = HttpUtil.get(request, "password");
	String regName = HttpUtil.get(request, "regName");
	String regEmail = HttpUtil.get(request, "regEmail");
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwd");
	String userName = HttpUtil.get(request, "userName");
	String userEmail = HttpUtil.get(request, "userEmail");
	
	logger.debug("userId - " + userId);
	logger.debug("userPwd - " + userPwd);
	logger.debug("userName - " + userName);
	logger.debug("userEmail - " + userEmail);
	
	logger.debug("regId - " + regId);
	logger.debug("password - " + password);
	logger.debug("regName - " + regName);
	logger.debug("regEmail - " + regEmail);
	logger.debug("cookieUserId - " + cookieUserId);
	
	UserDao userDao = new UserDao();
	
	// 회원가입 - 쿠키값이 없는 경우
	if(StringUtil.isEmpty(cookieUserId)){
		if(!StringUtil.isEmpty(regId) && !StringUtil.isEmpty(password) 	// Url에 직접 입력하는 경우를 위해.
				&& !StringUtil.isEmpty(regName) && !StringUtil.isEmpty(regEmail)){
			if(userDao.userSelectCount(regId) <= 0){
				// 회원가입 진행
				User user = new User();
				
				user.setUserId(regId);
				user.setUserPwd(password);
				user.setUserName(regName);
				user.setUserEmail(regEmail);
				user.setStatus("Y");
				
				if(userDao.userInsert(user) > 0){
					msg = "회원가입이 정상적으로 처리되었습니다.";
					redirectUrl = "/";
				}
				else{
					msg = "회원가입 중 오류가 발생하였습니다. 회원가입 페이지로 돌아가 다시 시도해 주세요.";
					redirectUrl = "/";
				}
			}
			else{ // DB에 regId로 넘어온 값과 일치하는 값이 있는 경우
				msg = "이미 존재하는 아이디입니다.";
				redirectUrl = "/";
			}
		}
		else{ // 회원가입정보 중 하나하도 입력값이 없는 경우
			msg = "회원가입 정보가 올바르게 입력되지 않았습니다.";
			redirectUrl = "/";
		}
		
	}
	
	// 회원정보수정 - 쿠키값이 있는 경우 -----------------------------------------------------------------------------
	else{
		User user = userDao.userSelect(cookieUserId);
		if(user != null){
			logger.debug("user.getStatus - " + user.getStatus());
			if(StringUtil.equals(user.getUserId(), userId)	 && StringUtil.equals(user.getStatus(), "Y")){
				if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)
					&& !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail) ){
					user.setUserId(userId);
					user.setUserPwd(userPwd);
					user.setUserName(userName);
					user.setUserEmail(userEmail);
					
					if(userDao.userUpdate(user) > 0){
						msg = "회원정보가 수정되었습니다.";
						redirectUrl = "/board/list.jsp";
					}
					else{
						msg = "회원정보 수정 중 오류가 발생하였습니다.";
						redirectUrl = "/userUpdateForm.jsp";
					}
				}
				else{
					msg = "변경하실 회원정보를 전부 입력해 주세요.";
					redirectUrl = "/userUpdateForm.jsp";
				}
			}
			else{ // 상태가 Y가 아닐경우
				CookieUtil.deleteCookie(request, response, "/", "USER_ID");
				msg = "정지된 사용자입니다. 다시 로그인해 주세요.";
				redirectUrl = "/";
			}
		}
		else{ // 쿠키에 있는 id가 다오를 통해 DB에서 못찾을 경우 
			CookieUtil.deleteCookie(request, response, "/", "USER_ID");
			msg = "올바른 사용자가 아닙니다.";
			redirectUrl = "/";
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>userProc</title>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
	alert("<%=msg %>");
	location.href = "<%=redirectUrl%>";
});

</script>

</head>
<body>




</body>
</html>