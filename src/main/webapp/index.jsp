<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인 페이지(로그인)</title>
<%@ include file="/include/head.jsp" %>
<link href="/resources/css/indexLog.css" rel="stylesheet">

<script>
// 로그인 시
$(document).ready(function(){
	$("#user").focus();
	
	$("#btnLogin").on("click", function(){
		fn_logincheck();
	});
	
});

function fn_logincheck(){
	if($.trim($("#userId").val()).length <= 0){
		alert("아이디를 입력해 주세요.");
		$("#userId").val("");
		$("#userId").focus();
		return;
	}
	if($.trim($("#userPwd").val()).length <= 0){
		alert("비밀번호를 입력해 주세요");
		$("#userPwd").val("");
		$("#userPwd").focus();
		return;
	}
	
	document.loginForm.submit();
}


// 회원 가입 시
$(document).ready(function(){
	
	$("#btnSignUp").on("click", function(){
		
		var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
		var emptCheck = /\s/g;
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
		
		if($.trim($("#regId").val()).length <= 0){
			alert("사용하실 아이디를 입력해 주세요.");
			$("#regId").val("");
			$("#regId").focus();
			return;
		}
		if(emptCheck.test($("#regId").val())){
			alert("아이디는 공백을 포함할 수 없습니다.");
			$("#regId").val("");
			$("#regId").focus();
			return;
		}
		if(!idPwCheck.test($("#regId").val())){
			alert("아이디는 4~12자의 영문 대소문자 및 숫자로만 입력가능합니다.");
			$("#regId").val("");
			$("#regId").focus();
			return;			
		}
		
		if($.trim($("#regName").val()).length <= 0){
			alert("사용자 이름을 입력해 주세요.");
			$("#regName").val("");
			$("#regName").focus();
			return;
		}
		
		
		if($.trim($("#password1").val()).length <= 0){
			alert("비밀번호를 입력해 주세요.");
			$("#password1").val("");
			$("#password1").focus();
			return;
		}
		if(emptCheck.test($("#password1").val())){
			alert("비밀번호는 공백을 포함할 수 없습니다.");
			$("#password1").val("");
			$("#password1").focus();
			return;
		}
		if(!idPwCheck.test($("#password1").val())){
			alert("비밀번호는 4~12자의 영문 대소문자 및 숫자로만 입력가능합니다.");
			$("#password1").val("");
			$("#password1").focus();
			return;			
		}
		if($.trim($("#password2").val()).length <= 0){
			alert("비밀번호확인을 입력해 주세요.");
			$("#password2").val("");
			$("#password2").focus();
			return;
		}
		if($("#password1").val() != $("#password2").val()){
			alert("비밀번호가 일치하지 않습니다. 다시 확인해 주세요.");
			$("#password2").val("");
			$("#password2").focus();
			return;
		}
		
		$("#password").val($("#password2").val());
		
		
		if($.trim($("#regEmail").val()).length <= 0){
			alert("사용자 이메일을 입력해 주세요.");
			$("#regEmail").val("");
			$("#regEmail").focus();
			return;
		}
		if(!emailReg.test($("#regEmail").val())){
			alert("사용자 이메일 형식이 올바르지 않습니다. 다시 입력하세요");
			//$("#userEmail").val("");
			$("#regEmail").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/userIdCheckAjax.jsp",
			data:{
				regId:$("#regId").val()
			},
			datatype:"JSON",
			success:function(obj){
				var data = JSON.parse(obj);
				
				if(data.flag == 0){
					document.signUpForm.submit();
				}
				else if(data.flag == 1){
					alert("이미 존재하는 아이디입니다. 다시 입력해 주세요.");
					$("#regId").focus();
				}
			},
			error:function(xhr, status, error){
				alert("오류 - 아이디 중복확인 오류 발생");
			}
		});
		
	});
});

function fn_Please(){
	$("#userId").val("");
	$("#userId").focus();
	return;
}

</script>

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

a:hover {
    cursor: pointer;
}
</style>
  


</head>


<body  style="background-color:#24335C">	<!-- #202D52 -->
<div class="login-wrap">
  <div class="login-html">
    <input id="tab-1" type="radio" name="tab" class="sign-in" checked><label for="tab-1" class="tab">Sign In</label>
    <input id="tab-2" type="radio" name="tab" class="sign-up"><label for="tab-2" class="tab">Sign Up</label>
    <div class="login-form"> 
    
 <form name="loginForm" id="loginForm" action="/loginProc.jsp" method="post" >
      <div class="sign-in-htm">
        <div class="group">
          <label for="userId" class="label">UserId</label>
          <input id="userId" name="userId" type="text" class="input">
        </div>
        <div class="group">
          <label for="userPwd" class="label">Password</label>
          <input id="userPwd" name="userPwd" type="password" class="input" data-type="password">
        </div>
        <div class="group">
          <input id="check" type="checkbox" class="check" checked>
          <label for="check"><span class="icon"></span> Keep me Signed in</label>
        </div>
        <div class="group">
          <button type="button" id="btnLogin" onClick="fn_logincheck()" class="button" value="Login">Login</button>
        </div>
        <div class="hr"></div>
        <div class="foot-lnk">
          <a onclick="fn_Please()">Please Sign in.</a>
        </div>
      </div> 
 </form>

<form name="signUpForm" id="signUpForm" action="/userProc.jsp" method="post" >
      <div class="sign-up-htm">
        <div class="group">
          <label for="regId" class="label">Id</label>
          <input id="regId" name="regId" type="text" class="input">
        </div>
        <div class="group">
          <label for="regName" class="label">name</label>
          <input id="regName" name="regName" type="text" class="input">
        </div>
        <div class="group">
          <label for="password1" class="label">Password</label>
          <input id="password1" name="password2" type="password" class="input" data-type="password">
        </div>
        <div class="group">
          <label for="password2" class="label">Repeat Password</label>
          <input id="password2" name="password2" type="password" class="input" data-type="password">
        </div>
        <div class="group">
          <label for="regEmail" class="label">Email Address</label>
          <input id="regEmail" name="regEmail" type="text" class="input">
        </div>
        <div class="group">
          <button type="button" id="btnSignUp" class="button" value="Sign Up">Sign Up</button>
        </div>
        <input type="hidden" id="password" name="password" value="" />
        <div class="hr"></div>
        <div class="foot-lnk">
          <label for="tab-1"><a>Already Member?</a>
        </div>
      </div>
</form>

      
    </div>
  </div>
</div>	

<div>


</body>
</html>