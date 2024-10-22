<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging" %>
<%@ page import="com.sist.web.model.BoardFileConfig" %>

<%
	Logger logger = LogManager.getLogger("/board/list.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	long totalCount = 0;
	List<Board> list = null;
	Paging paging = null;
	
	BoardDao boardDao = new BoardDao();
	Board search = new Board();
	
	if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)){
		if(StringUtil.equals(searchType, "1")){
			search.setBbsName(searchValue);
		}
		else if(StringUtil.equals(searchType, "2")){
			search.setBbsTitle(searchValue);
		}
		else if(StringUtil.equals(searchType, "3")){
			search.setBbsContent(searchValue);
		}
	}
	
	totalCount = boardDao.boardTotalCount(search);
	
	logger.debug("[board/list.jsp] 게시판 총 게시물 수 - "+ totalCount);
	
	if(totalCount > 0){
		paging = new Paging(totalCount, BoardFileConfig.LIST_COUNT, BoardFileConfig.PAGE_COUNT, curPage);
		
		search.setStartRow(paging.getStartRow());
		search.setEndRow(paging.getEndRow());
		
		list = boardDao.boardList(search);
	}

%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<meta charset="UTF-8">
<title>list</title>

<script>

$(document).ready(function() {
	
	$("#_searchType").change(function(){
		$("#_searchValue").val("");
		$("#_searchValue").focus();
	});
	
	$("#btnSearch").on("click", function(){
		if($("#_searchType").val() != ""){
			if($.trim($("#_searchValue").val()) == ""){
				alert("조회항목에 대한 조회값을 입력해 주세요.");
				$("#_searchValue").val("");
				$("#_searchValue").focus();
				return;
			} 
		}
		
		document.bbsForm.bbsSeq = "";
		document.bbsForm.searchType.value = $("#_searchType").val();
		document.bbsForm.searchValue.value = $("#_searchValue").val();
		document.bbsForm.curPage.value = "";
		document.bbsForm.action = "/board/list.jsp";
		document.bbsForm.submit();
	});
	
	$("#btnWrite").on("click", function(){
		document.bbsForm.bbsSeq = "";
		document.bbsForm.action = "/board/write.jsp";
		document.bbsForm.submit();
	});

});

function fn_view(bbsSeq){
	document.bbsForm.bbsSeq.value = bbsSeq;
	document.bbsForm.action = "/board/view.jsp";
	document.bbsForm.submit();
}

function fn_list(curPage){
	document.bbsForm.bbsSeq.value = "";
	document.bbsForm.curPage.value = curPage;
	document.bbsForm.action = "/board/list.jsp";
	document.bbsForm.submit();
}

</script>

<style>
 .container {
   margin-top: 70px;
 }
</style>

</head>
<body class="">
<%@ include file="/include/navigation.jsp" %>


<div class="container">
   <div class="d-flex">
	<div style="width:50%; margin-bottom:15px;">
	   <h2><b>게시판</b></h2>
	</div>
      <div class="ml-auto input-group" style="width:50%;">
         <select name="_searchType" id="_searchType" class="custom-select" style="width:auto;">
            <option value="">조회 항목</option>
            <option value="1" <%if(StringUtil.equals(searchType, "1")){%>selected<%}%> >작성자</option>
            <option value="2" <%if(StringUtil.equals(searchType, "2")){%>selected<%}%> >제목</option>
            <option value="3" <%if(StringUtil.equals(searchType, "3")){%>selected<%}%> >내용</option>
         </select>
         <input type="text" name="_searchValue" id="_searchValue" value="<%=searchValue %> " class="form-control mx-1" maxlength="20" style="width:auto;ime-mode:active;" placeholder="조회값을 입력하세요." />
         <button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">조회</button>
      </div>
    </div>
    
	<table class="table table-hover">
		<thead>
			<tr style="background-color: #dee2e6;">
				<th scope="col" class="text-center" style="width:10%">번호</th>
				<th scope="col" class="text-center" style="width:45%">제목</th>
				<th scope="col" class="text-center" style="width:10%">작성자</th>
				<th scope="col" class="text-center" style="width:25%">날짜</th>
				<th scope="col" class="text-center" style="width:10%">조회수</th>
			</tr>
		</thead>


     
		<tbody>
<%
if(list != null && list.size() >0){
	long startNum = paging.getStartNum();
	for(int i = 0; i < list.size(); i++){
		Board board = list.get(i);
%>	 
			<tr>
				<td class="text-center"><%=startNum %></td>
				<td><a href="javascript:void(0)" onclick="fn_view(<%=board.getBbsSeq() %>)"  style="color: #3D4C74;" ><%=board.getBbsTitle() %></a></td>
				<td class="text-center"><%=board.getBbsName() %></td>
				<td class="text-center"><%=board.getRegDate() %></td>
				<td class="text-center"><%=board.getBbsReadCnt() %></td>
			</tr>
<%
		startNum--;
	}
}
else{
%>
			<tr>
				<td colspan="5" class="text-center"><b>게시물이 없습니다.</b></td>
			</tr>
<%
}
%>			
		</tbody>


		<tfoot>
			<tr>
				<td colspan="5"></td>
			</tr>
		</tfoot>
	</table>

<!-- 페이징 블럭 -->

	<nav>
		<ul class="pagination justify-content-center">
<%
if(paging != null){
	if(paging.getPrevBlockPage() > 0){
		
%>
			<!-- li class="page-item"><a class="page-link" href="">처음</a></li -->         
			<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging.getPrevBlockPage() %>)">이전블럭</a></li>
<%
	}
	for(long i = paging.getStartPage(); i <= paging.getEndPage(); i++){
		if(paging.getCurPage() == i){
%>			
			<li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;background-color: #3D4C74; "><%=i %></a></li>
<%
		}
		else{
%>
			<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=i %>)" style="color: #3D4C74;" ><%=i %></a></li>
<%
		}
	}
	if(paging.getNextBlockPage() > 0){
%>			
			<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging.getNextBlockPage() %>)" style="color: #66718D;">다음블럭</a></li>
<%
	}
}
%>		
		</ul>
	</nav>
   
   <button type="button" id="btnWrite" class="btn btn-secondary mb-3" style="background-color: #3D4C74; color: white;">글쓰기</button>
   
   
   <form name="bbsForm" id="bbsForm" method="post" >
   		<input type="hidden" name="bbsSeq" value="" />
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
   </form>
   
</div>
</body>
</html>