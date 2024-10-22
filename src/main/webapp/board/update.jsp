<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>


<%
	Logger logger = LogManager.getLogger("/board/update.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bbsSeq);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>update</title>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
<%
if(board == null){
%>
	alert("게시물이 존재하지 않습니다.");
	location.href = "/board/list.jsp";
<%
}
else{
%>
	$("#bbsTitle").focus();
	
	$("#btnList").on("click", function(){
		document.bbsForm.action = "/board/list.jsp";
		document.bbsForm.submit();
	});
	
	$("#btnUpdate").on("click", function(){
		if($.trim($("#bbsTitle").val()).length <= 0){
			alert("수정하실 제목을 입력해 주세요");
			$("#bbsTitle").val("");
			$("#bbsTitle").focus();
			return;
		}
		if($.trim($("#bbsContent").val()).length <= 0){
			alert("수정하실 제목을 입력해 주세요");
			$("#bbsContent").val("");
			$("#bbsContent").focus();
			return;
		}
		
		if(confirm("입력하신 내용으로 수정하시겠습니까?") == true){
			document.updateForm.submit();
		}
	});
<%
}
%>
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
   <h2><b>게시물 수정</b>
<form name="updateForm" id="updateForm" action="/board/updateProc.jsp" method="post">
	<input type="text" name="bbsName" id="bbsName" maxlength="20" value="<%=board.getBbsName() %>" style="ime-mode:active;" value="이름 " class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
	<input type="text" name="bbsEmail" id="bbsEmail" maxlength="30" value="<%=board.getUserId() %>"  style="ime-mode:inactive;" value="아이디 " class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
	<input type="text" name="bbsTitle" id="bbsTitle" maxlength="100" style="ime-mode:active;" value="<%=board.getBbsTitle() %> " class="form-control mb-2" placeholder="제목을 입력해주세요." required />
	<div class="form-group">
		<textarea class="form-control" rows="10" name="bbsContent" id="bbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required><%=board.getBbsContent() %></textarea>
	</div>
	<input type="hidden" name="bbsSeq" value="<%=bbsSeq%>"/>
	<input type="hidden" name="searchType" value="<%=searchType %>" />
	<input type="hidden" name="searchValue" value="<%=searchValue %>" />
	<input type="hidden" name="curPage" value="<%=curPage %>" />
</form>
   
	<div class="form-group row">
		<div class="col-sm-12">
			<button type="button" id="btnUpdate" class="btn btn-primary" title="수정" style="background-color: #3D4C74; color: white;" >수정</button>
			<button type="button" id="btnList" class="btn btn-primary" title="리스트" style="background-color: #3D4C74; color: white;" >리스트</button>
		</div>
	</div>
</div>

<form name="bbsForm" id="bbsForm" method="post">	<!--  -->
	<input type="hidden" name="bbsSeq" value="<%=bbsSeq%>"/>
	<input type="hidden" name="searchType" value="<%=searchType %>" />
	<input type="hidden" name="searchValue" value="<%=searchValue %>" />
	<input type="hidden" name="curPage" value="<%=curPage %>" />	
</form>

</body>
</html>