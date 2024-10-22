<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>img</title>
<%@ include file="/include/head.jsp" %>

<style>
body {
    margin: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100vh; /* 뷰포트의 100% 높이 */
    background-color: #f0f0f0; /* 배경 색상을 원하는 색으로 지정 (선택 사항) */
}

img {
    max-width: 90%;
    max-height: 100vh; /* 뷰포트의 100% 높이까지만 이미지의 높이를 설정 */
    display: block;
    margin: auto;
    cursor: pointer;
}
</style>
</head>
<body>
<img src="/1.jpg" href="/board/list.jsp" alt="대체 텍스트">

<script>
	// 이미지를 클릭했을 때 페이지 이동
	document.querySelector('img').addEventListener('click', function() {
	    window.location.href = '/board/list.jsp';
	});
</script>

</body>
</html>