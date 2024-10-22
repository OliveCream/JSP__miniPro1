<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("loginProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwd");
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	String msg = "";
	String redirectUrl = "";
	
	User user = null;
	UserDao userDao = new UserDao();
	
	logger.debug("userId - " + userId);
	logger.debug("userPwd - " + userPwd);
	logger.debug("cookieUserId - " + cookieUserId);

	
	if(StringUtil.isEmpty(cookieUserId)){
		logger.debug("쿠키정보가 없을 경우 -----------------------------------");
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)){
			user = userDao.userSelect(userId);
			if(user != null){
				if(StringUtil.equals(userPwd, user.getUserPwd())){
					if(StringUtil.equals(user.getStatus(), "Y")){
						CookieUtil.addCookie(response, "USER_ID", userId);
						CookieUtil.addCookie(response, "/", "USER_ID", userId);
						msg = "로그인 성공";
						redirectUrl = "/board/list.jsp";
					}
					else{// 상태가 정지일때
						msg = "정지된 회원입니다.";
						redirectUrl = "/";
					}
				}
				else{// 비밀번호가 같지 않을 때
					msg = "비밀번호가 일치하지 않습니다.";
					redirectUrl = "/";
				}
			}
			else{	//유저객체 null일때 (DB에 회원아이디가 존재하지 않을 때)
				msg = "아이디가 존재하지 않습니다.";
				redirectUrl = "/";
			}
		}
		else{	// 아이디 또는 비밀번호 값이 넘어오지 않았을 경우
			msg = "아이디 또는 비밀번호 값을 입력해 주세요.";
			redirectUrl = "/";
		}

		
	}
	else{	//쿠키정보 있을 경우
		logger.debug("쿠키정보가 있을 경우 -----------------------------------");
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)){
			user = userDao.userSelect(userId);
			if(user != null){
				if(StringUtil.equals(userPwd, user.getUserPwd())){
					if(StringUtil.equals(user.getStatus(), "Y")){
						if(!StringUtil.equals(userId, cookieUserId)){
							CookieUtil.deleteCookie(request, response, "USER_ID");
							CookieUtil.addCookie(response, "USER_ID", userId);
						}
						msg = "로그인 성공!";
						redirectUrl = "/board/list.jsp";
					}
					else{// 회원상태가 정지 일 경우
						msg = "정지된 회원입니다.";
						redirectUrl ="/";
					}
				}
				else{
					msg = "비밀번호가 일치하지 않습니다.";
					redirectUrl ="/";
				}
			}
			else{// 유저객체가 null일 경우
				msg = "아이디가 존재하지 않습니다.";
				redirectUrl ="/";
			}
		}
		else{	// 아이디 또는 비밀번호 값이 넘어오징 않았을 경우
			msg = "아이디 또는 비밀번호 값을 입력해 주세요.";
			redirectUrl = "/";
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>loginProc</title>
  <style>
    body {
      background: linear-gradient(to bottom, #24335C, white);
      height: 100vh;
      color: #fff;
    }
    
  </style>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function(){
	alert("<%=msg %>");
	location.href = "<%=redirectUrl%>";
});
</script>


</head>

<body class="aa">

</body>
</html>