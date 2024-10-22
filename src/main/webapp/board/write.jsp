<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("/board/write.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieUserId);
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>write</title>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function() {
	$("#bbsTitle").focus();
	
	$("#btnList").on("click", function(){
		document.bbsForm.action = "/board/list.jsp";
		document.bbsForm.submit();
	});
	
	$("#btnWrite").on("click", function(){
		if($.trim($("#bbsTitle").val()).length <= 0){
			alert("제목을 입력해 주세요.");
			$("#bbsTitle").val("");
			$("#bbsTitle").focus();
			return;
		}
		if($.trim($("#bbsContent").val()).length <= 0){
			alert("내용을 입력해 주세요.");
			$("#bbsContent").val("");
			$("#bbsContent").focus();
			return;
		}
		
		document.writeForm.submit();
	});
	
});

</script>

  <style>
 
 .container {
   margin-top: 70px;  /* 내비게이션 바와 본문 간의 간격 조절 */
 }
</style>

</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   <h2><b>게시물 쓰기</b></h2>

	<form name="writeForm" id="writeForm" action="/board/writeProc.jsp" method="post">
		<input type="text" name="bbsName" id="bbsName" maxlength="20" value="<%=user.getUserName() %> " style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
		<input type="text" name="bbsEmail" id="bbsEmail" maxlength="30" value="<%=user.getUserEmail() %> " style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
		<input type="text" name="bbsTitle" id="bbsTitle" maxlength="100" style="ime-mode:active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
		<div class="form-group">
			<textarea class="form-control" rows="10" name="bbsContent" id="bbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required></textarea>
		</div>
	
		<div class="form-group row">
			<div class="col-sm-12">
				<button type="button" id="btnWrite" class="btn btn-primary" title="저장" style="background-color: #3D4C74;">저장</button>
				<button type="button" id="btnList" class="btn btn-secondary" title="리스트" style="background-color: #3D4C74;">리스트</button>
			</div>
		</div>
	</form>
   
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
	</form>

</div>

</body>
</html>