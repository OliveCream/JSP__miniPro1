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
	
	boolean upSuccess = false;
	String errorMsg = "";
	
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	String bbsTitle = HttpUtil.get(request, "bbsTitle", "");
	String bbsContent = HttpUtil.get(request, "bbsContent", "");
	
	if(bbsSeq > 0 && !StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent)){
		BoardDao boardDao = new BoardDao();
		Board board = boardDao.boardSelect(bbsSeq);
		
		if(board != null){
			if(StringUtil.equals(cookieUserId, board.getUserId())){
				board.setBbsTitle(bbsTitle);
				board.setBbsContent(bbsContent);
				
				if(boardDao.boardUpdate(board) > 0){
					upSuccess = true;
				}
				else{
					errorMsg = "게시물 수정 중 오류가 발생하였습니다.";
				}
			}
			else{
				errorMsg = "본인이 작성한 게시물만 수정 가능합니다.";
			}
		}
		else{
			errorMsg = "게시물이 존재하지 않습니다.";
		}
	}
	else{
		errorMsg = "게시물 수정 입력값이 제대로 입력되지 않았습니다.";
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateProc</title>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
<%
if(upSuccess == true){
%>
	alert("게시물이 수정되었습니다.");
	document.bbsForm.action = "/board/view.jsp";
	document.bbsForm.submit();
<%
}
else{
%>
	alert("<%=errorMsg %>");
	location.href = "board/list.jsp";
<%
}
%>
});
</script>



</head>
<body>
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="bbsSeq" value="<%=bbsSeq %>" />
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
	</form>
</body>
</html>