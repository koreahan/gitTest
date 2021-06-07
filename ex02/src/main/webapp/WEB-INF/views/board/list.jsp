<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Board</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<link rel="stylesheet" href="/resources/assets/css/main.css" />
		<style>
			.big-width{display:block;}
			.small-width{display:none;}
			.table-wrapper {overflow-x:hidden !important;}
			select{width: 25%;display: inline;}
			input[name='keyword']{width: 54%; display: inline;}
			.search{width: 20%;}
			
			@media (max-width: 918px){
				.writer {display:none;}
				.regDate {display:none;}
				.updateDate {display:none;}
				.big-width{display:none;}
				.small-width{display:block;}
				select{width: 100%;}
				input[name='keyword']{width: 100%;}
				.search{width: 100%;}
			}
		</style>
	</head>
	<body class="is-preload">
		<!-- Main -->
			<div id="main">
				<div class="wrapper">
					<div class="inner">

						<!-- Elements -->
							<header class="major">
								<h1>Board</h1>
								<p>게시판 목록</p>
							</header>
									<!-- Table -->
										<h3><a href="/board/register${pageMaker.cri.getListLink()}" class="button small">글 등록</a></h3>
										<div class="table-wrapper">
											<table>
												<thead>
													<tr class="tHead">
														<th class="bno">번호</th>
														<th class="title">제목[댓글]</th>
														<th class="writer">작성자</th>
														<th class="regDate">작성일</th>
														<th class="updateDate">수정일</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach var="board" items="${list}">
														<tr class="tBody">
															<td class="bno">${board.bno}</td>
															<td class="title"><a href="/board/get${pageMaker.cri.getListLink()}&bno=${board.bno}">${board.title}</a><span style="font-size:0.5rem">[${board.replyCnt}]</span></td>
															<td class="writer">${board.writer}</td>
															<td class="regDate">${board.regDate}</td>
															<td class="updateDate">${board.updateDate}</td>
														</tr>
													</c:forEach>
												</tbody>
												<tfoot>
												</tfoot>
											</table>
											<!-- A -->
											<form action="/board/list" id="searchForm">
												<div class="fields">
													<div class="field">
														<div style="text-align:center">
															<select name="type">
																<option value="" ${pageMaker.cri.type == null ? 'selected' : ''}>검색 기준</option>
																<option value="T" ${pageMaker.cri.type == 'T' ? 'selected' : ''}>제목</option>
																<option value="C" ${pageMaker.cri.type == 'C' ? 'selected' : ''}>내용</option>
																<option value="W" ${pageMaker.cri.type == 'W' ? 'selected' : ''}>작성자</option>
																<option value="TC" ${pageMaker.cri.type == 'TC' ? 'selected' : ''}>제목 또는 내용</option>
																<option value="TW" ${pageMaker.cri.type == 'TW' ? 'selected' : ''}>제목 또는 작성자</option>
																<option value="TCW" ${pageMaker.cri.type == 'TCW' ? 'selected' : ''}>전체</option>
															</select>
															<input id="keyword" type="text" name="keyword" value="${pageMaker.cri.keyword}">
															<a href="javascript:void(0)" class="search button primary icon solid fa-search">검색</a>
														</div>
													</div>
												</div>
											</form>
											<div class="big-width" style="text-align:center;">
												<c:if test="${pageMaker.prev}">
													<a class="changePage" href="${1}"><code>&lt;&lt;</code></a>
													<a class="changePage" href="${pageMaker.startPage - 1}"><code>&lt;</code></a>
												</c:if>
												<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
													<c:choose>
														<c:when test="${num eq pageMaker.cri.pageNum}">
															<code>${num}</code>
														</c:when>
														<c:otherwise>
															<a class="changePage" href="${num}"><code>${num}</code></a>
														</c:otherwise>
													</c:choose>
												</c:forEach>
												<c:if test="${pageMaker.next}">
													<a class="changePage" href="${pageMaker.endPage + 1}"><code>&gt;</code></a>
													<a class="changePage" href="${pageMaker.realEnd}"><code>&gt;&gt;</code></a>
												</c:if>
											</div>
											
											<div class="small-width" style="text-align:center;">
												<c:if test="${pageMaker.cri.pageNum > 1}">
													<a class="changePage" href="${1}"><code>&lt;&lt;</code></a>
													<a class="changePage" href="${pageMaker.cri.pageNum - 1}"><code>&lt;</code></a>
												</c:if>
												<code>${pageMaker.cri.pageNum}</code>
												<c:if test="${pageMaker.cri.pageNum < pageMaker.realEnd}">
													<a class="changePage" href="${pageMaker.cri.pageNum + 1}"><code>&gt;</code></a>
													<a class="changePage" href="${pageMaker.realEnd}"><code>&gt;&gt;</code></a>
												</c:if>
											</div>
											
											<form id="actionForm" action="/board/list">
												<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
												<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
												<input type="hidden" name="type" value="${pageMaker.cri.type}">
												<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
											</form>
											<!-- B -->
										</div>
								</div>
							</div>
						</div> 
		<!-- Scripts -->
			<script src="/resources/assets/js/jquery.min.js"></script>
			<script src="/resources/assets/js/jquery.dropotron.min.js"></script>
			<script src="/resources/assets/js/browser.min.js"></script>
			<script src="/resources/assets/js/breakpoints.min.js"></script>
			<script src="/resources/assets/js/util.js"></script>
			<script src="/resources/assets/js/main.js"></script>
	</body>
	<script>
		$("a.search").on("click", function(e){
			e.preventDefault();
			var searchForm = $("#searchForm");
			
			if(!searchForm.find("option:selected").val()){
				alert("검색 종류를 선택하세요.");
				return false;
			}
			if(!searchForm.find("input[name='keyword']").val()){
				alert("키워드를 입력하세요.");
				return false;
			}
			searchForm.submit();
		})
	
		$(".changePage").on("click", function(e){
			e.preventDefault();
			var actionForm = $("#actionForm");
			var pageNum = $(this).attr("href");
			actionForm.find("input[name='pageNum']").val(pageNum);
			actionForm.submit();
		})
	
		//alert("${result}");
		var result = "${result}";
		$(document).ready(function(){
			if(result == '' || isNaN(result)){
				return;
			}
			alert("게시글 " + result + "번이 등록되었습니다.")
		})
	</script>
</html>



















