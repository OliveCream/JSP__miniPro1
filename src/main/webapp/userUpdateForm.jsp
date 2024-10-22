<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>


<%
	Logger logger = LogManager.getLogger("userUpdateForm.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String msg = "";
	
	User user = null;
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	//url 에 userId와 userPwd를 치고 들어올 경우 1.id가 DB에 존재해야하고 2.비밀번호도 일치하고 3.쿠키id 까지 일치해야 수정 가능
// 	String userId = HttpUtil.get(request, "userId");		// 없음 게시판 페이지에서 넘기는 값이 없음
// 	if(user.getUserId() != cookieUserId){
// 		out.println("<script> alert('잘못된 접근입니다.''); <script>");
// 		msg = "잘못된 접근입니다.";
// 		response.sendRedirect("/");
// 	}
	
	if(!StringUtil.isEmpty(cookieUserId)){
		logger.debug("cookieUserId : " + cookieUserId);
		
		UserDao userDao = new UserDao();
		user = userDao.userSelect(cookieUserId);
		
		if(user == null){
			CookieUtil.deleteCookie(request, response, "/", "USER_ID");
			response.sendRedirect("/");
		}
		else{ // 쿠키존재 + DB에도 존재
			
			if(!StringUtil.equals(user.getStatus(), "Y")){
				CookieUtil.deleteCookie(request, response, "/", "USER_ID");
				user = null;
				response.sendRedirect("/");
			}	
		}
	}
	
	if(user != null){
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>userUpdateForm</title>
<%@ include file="/include/head.jsp" %>
<link href="/resources/css/indexLog.css" rel="stylesheet">
<script>
$(document).ready(function(){
	$("#btnUserUpdate").on("click", function(){
		var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
		var emptCheck = /\s/g;
		var emailCheck = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
		
		if($.trim($("#userPwd1").val()).length <= 0){
			alert("변경하실 비밀번호를 입력해 주세요.");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		if(emptCheck.test($("#userPwd1").val())){
			alert("비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		if(!idPwCheck.test($("#userPwd1").val())){
			alert("비밀번호는 4~12자의 영문 대소문자 및 숫자로만 입력가능합니다.");
			$("#userPwd1").focus();
			return;
		}
		if($.trim($("#userPwd2").val()).length <= 0){
			alert("비밀번호 확인을 입력해 주세요.");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}
		if($("#userPwd1").val() != $("#userPwd2").val()){
			alert("비밀번호가 일치하지 않습니다");
			$("#userPwd2").focus();
			return;
		}
		
		$("#userPwd").val($("#userPwd1").val());
		
		//-----
		if($.trim($("#userName").val()).length <= 0){
			alert("사용자 이름을 입력하세요.");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}
		if($.trim($("#userEmail").val()).length <= 0){
			alert("이메일을 입력하세요.");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		if(!emailCheck.test($("#userEmail").val())){
			alert("사용자 이메일 형식이 올바르지 않습니다.");
			$("#userEmail").focus();
			return;
		}
		
		document.updateForm.submit();
		
	});
});

</script>
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh; /* 뷰포트 높이의 100% */
      margin: 0; /* 기본 마진 제거 */
    }
  </style>
  
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      margin: 0;
      background: linear-gradient(to bottom, #495678, #E2E4E9);
      height: 100vh;
      color: #fff;
    }
  </style>
  
</head>
<body>

<body>	<!-- #202D52 -->
<div class="login-wrap">
  <div class="login-html">
    <input id="tab-1" type="radio" name="tab" class="sign-in" checked><label for="tab-1" class="tab">userUpdate</label>
    <input id="tab-2" type="radio" name="tab" class="sign-up"><label for="tab-2" class="tab"></label>
    <div class="login-form">
      <div class="sign-in-htm">
<form name="updateForm" id="updateForm" action="/userProc.jsp" method="post">
        <div class="group">
          <label for="updatId" class="label" >userId</label>
          <input type="text" value="<%=user.getUserId() %>" class="input" readonly> <!-- disable -->
        </div>
        <div class="group">
          <label for="userPwd1" class="label">Password</label>
          <input id="userPwd1" name="userPwd1" type="password" value="<%=user.getUserPwd() %>" class="input" data-type="password">
        </div>        
        <div class="group">
          <label for="userPwd2" class="label">Repeat Password</label>
          <input id="userPwd2" name='userPwd2' type="password" value="<%=user.getUserPwd() %>" class="input" data-type="password">
        </div>
        <div class="group">
          <label for="userName" class="label">Username</label>
          <input id="userName" name="userName" type="text" value="<%=user.getUserName() %>" class="input">
        </div>
        <div class="group">
          <label for="userEmail" class="label">Email Address</label>
          <input id="userEmail" name="userEmail" type="text" value="<%=user.getUserEmail() %>" class="input">
        </div>

        <div class="group">
          <button type="button" id="btnUserUpdate" class="button" value="Update">UserUpdate</button>
        </div>
        
       <input type="hidden" id="userId" name="userId" value="<%=user.getUserId() %>" />
       <input type="hidden" id="userPwd" name="userPwd" value="" />
       
</form>
        <div class="hr"></div>

      </div>

      </div>
    </div>
  </div>
</div>	




</body>

</html>

<%
	}
%>

