<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.dao.CommentDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.web.model.Comment" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging" %>
<%@ page import="com.sist.web.model.BoardFileConfig" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<% 
	Logger logger = LogManager.getLogger("/board/commentUpdate.jsp");
	HttpUtil.requestLogString(request, logger);
	
	boolean regSuccess = false;
	String errorMsg = "";
	
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	String userId = HttpUtil.get(request, "cookieUserId");
	String ccsName = HttpUtil.get(request, "ccsName");
	String ccsContent = HttpUtil.get(request, "ccsContent");
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	CommentDao commentDao = new CommentDao();
	Comment comment = new Comment();
	
	if(bbsSeq >= 0 && !StringUtil.isEmpty(ccsName) && !StringUtil.isEmpty(ccsContent)){
		
		if(StringUtil.equals(userId, CookieUtil.getValue(request, "USER_ID"))){
			comment.setBbsSeq(bbsSeq);
			comment.setUserId(userId);
			comment.setCcsName(ccsName);
			comment.setCcsContent(ccsContent);
			
			
			if(commentDao.commentInsert(comment) > 0){
				regSuccess = true;
			}
			else{
				errorMsg = "댓글 등록 중 오류가 발생하였습니다. 다식 작성해 주세요.";
			}
		}	
	}
	else{
		errorMsg = "댓글 등록 값이 잘못되었습니다.";
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>commentUpdate</title>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
	<%	
		if(regSuccess == true){
	%>
			// 정상적으로 처리
			alert("댓글이 등록되었습니다.");
			document.ccsForm.action = "/board/view.jsp";
			document.ccsForm.submit();
	<%
		}
		else{
	%>
			// 오류처리
			alert("<%=errorMsg %>");
			location.href = "/board/view.jsp";
	<%
		}
	%>
	});
</script>

</head>
<body>
	<form name="ccsForm" id="ccsForm" method="post">
		<input type="hidden" name="bbsSeq" value="<%=bbsSeq %>" />
		<input type="hidden" name="ccsSeq" value="<%=comment.getCcsSeq() %>" />
		<input type="hidden" name="searchType" value=<%=searchType %> />
		<input type="hidden" name="searchValue" value=<%=searchValue %> />
		<input type="hidden" name="curPage" value=<%=curPage %> />
	</form>
</body>
</html>