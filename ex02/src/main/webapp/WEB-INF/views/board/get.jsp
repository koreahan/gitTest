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
		.uploadResult{
			width:100%;
		}
		.uploadResult ul{
			display:flex;
			justify-content:center;
		}
		
		.uploadResult ul li{
			list-style:none;
			padding:10px;
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
	                  <p>게시글 등록</p>
	               </header>
					<h3><a href="/board/list${cri.getListLink()}" class="button small">목록 보기</a></h3>
                  <div class="content">
                     <div class="form">
                        <form action="/board/remove">
                        	<input type="hidden" name="pageNum" value="${cri.pageNum}">
							<input type="hidden" name="amount" value="${cri.amount}">
                        	<input type="hidden" name="type" value="${cri.type}">
							<input type="hidden" name="keyword" value="${cri.keyword}">
                           <div class="fields">
                              <div class="field">
                                 <h4>번호</h4>
                                 <input name="bno" type="text" value="${board.bno}" readonly/>
                              </div>
                              <div class="field">
                                 <h4>제목</h4>
                                 <input name="title" type="text" value="${board.title}" readonly/>
                              </div>
                              <div class="field">
                                 <h4>내용</h4>
                                 <textarea name="content" rows="6" style="resize:none" readonly>${board.content}</textarea>
                              </div>
                              <div class="field">
                                 <h4>작성자</h4>
                                 <input name="writer" type="text" value="${board.writer}" readonly/>
                              </div>
                              <div class="field uploadDiv">
								<div class="field uploadDiv">
									<h4>첨부파일</h4>
								</div>
								<div class="field">
									<div class="uploadResult">
										<ul></ul>
									</div>
								</div>
								<div class="bigPictureWrapper">
									<div class="bigPicture"></div>
								</div>
                           </div>
                           <ul class="actions special">
                              <li>
                                 <input type="button" class="button" value="수정" onclick="location.href='/board/modify${cri.getListLink()}&bno=${board.bno}'"/>
                                 <input type="submit" class="button" value="삭제"/>
                              </li>
                           </ul>
                           </div>
                           <ul class="icons">
                           	<li>
                           		<span class="icon solid fa-envelope"></span>
                           		<strong>댓글</strong>
                           	</li>
                           </ul>
                           <a href="javascript:void(0)" class="button primary small register" style="width: 100%;">댓글 등록</a>
                           <div class="fields register-form" style="display: none;">
                           	<div class="field">
                           		<h4>작성자</h4>
                           		<input type="text" name="replyer" placeholder="Replyer">
                           	</div>
                           	<div class="field">
                           		<h4>댓글</h4>
                           		<textarea rows="6" name="reply" placeholder="Reply" style="resize: none;"></textarea>
                           	</div>
                           	<div class="field">
                           		<a href="javascript:void(0)" class="button primary small finish">등록</a>
                           		<a href="javascript:void(0)" class="button primary small cancel">취소</a>
                           	</div>
                           </div>
                           <ul class="replies">
                           </ul>
							<div class="paging" style="text-align: center;">
							</div>
                        </form>
                     </div>
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
         <script src="/resources/assets/js/reply.js"></script>
   </body>
   <script>
   	$(document).ready(function(){
   		
   		//썸네일 li태그를 클릭하면 들어옴
   		$(".uploadResult").on("click", "li", function(e){
   			console.log("view or download")
   			var li = $(this);
   			var path = encodeURIComponent(li.data("path") + "/" + li.data("uuid") + "_" + li.data("filename"));
   			
   			if(li.data("type")){//type은 true일 경우 이미지이다.
   				//썸네일의 원본 보여주기
   				showImage(path.replace(new RegExp(/\\/g), "/")); // '\'를 '/'로 모두 변경(\가 JS에서 명령어로 인식될 수 있기 때문)
   			}else{
   				//다운로드(현재 페이지에서 클릭한 파일 다운로드 받기)
   				self.location = "/download?fileName=" + path; 
   			}
   		});
   		var check = false;
   		function showImage(path){
   			if(check){return;}
   			$(".bigPictureWrapper").css("display", "flex").show();
   			$(".bigPicture").html("<img src='/display?fileName=" + path + "'>")
   			.animate({width:'100%', height:'100%'}, 1000);
   			check = true;
   			
   		}
		$(".bigPictureWrapper").on("click", function(e){
			if(!check){return;}
			$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
			setTimeout(function(){
				$(".bigPictureWrapper").hide();
				check = false;
			}, 1000);
		});
   		(function(){
   			var bno = "${board.bno}";
   			console.log(bno);
   			//해당 게시글에 첨부된 모든 파일을 가져온다.
   			$.getJSON("/board/getAttachList", {bno:bno}, function(list){
   				var str = "";
   				
   				$(list).each(function(i, obj){
   					if(obj.fileType){
   						var thumbPath = encodeURIComponent(obj.uploadPath + "\\s_" + obj.uuid + "_" + obj.fileName);
						str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
						str += "<div><img src='/display?fileName=" + thumbPath + "' width=100 height=100>";
						str += "<br>" + obj.fileName;
						str += "</div></li>";
   					}else{
   						str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
						str += "<div><img src='/resources/images/attach.png' width=100 height=100>";
						str += "<br>" + obj.fileName;
						str += "</div></li>";
   					}
   				});
   				$(".uploadResult ul").html(str);
   			});
   		})();
   		
   		var pageNum = 1;
   		var bno = "${board.bno}";
   		
   		showList(pageNum);
   		
   		$(".register").on("click", function(e){
   			e.preventDefault();
   			$(".register-form").show();
   			$(this).hide();
   		});
   		
   		$(".cancel").on("click", function(e){
   			e.preventDefault();
   			$(".register-form").hide();
   			$(".register").show();
   		})
   		
   		//jQuery를 사용했던 이유
   		//웹 표준으로 개발되던 시대가 아니였을 때에는 개발자가 버전별로 다양한 언어들을 공부해야 했다.
   		//그렇기 때문에 웹 표준을 정해놓으면 개발자들이 편하게 개발할 수 있는 상태였다.
   		//바로 이 때 jQuery를 만든 회사에서 JS의 표준화 즉, 통일성을 주기 위해서 홍보를 하였고,
   		//jQuery 개발자가 대량으로 늘어나며, 거의 모든 프로젝트에서 jQuery가 사용되었다.
   		//하지만 지금은 거의 대부분의 브라우저는 W3C에 의해 표준화된 웹 표준을 사용하기 때문에
   		//jQuery의 목적성을 잃어 가고 있다.
   		
   		$(".finish").on("click", function(e){
   			e.preventDefault();
   			//댓글 작성자, 댓글
   			var replyer = $("input[name='replyer']").val();
   			var reply = $("textarea[name='reply']").val();
   			
   			if(replyer == "" || reply == ""){return;}
   			
   			replyService.add({bno:bno, reply:reply, replyer:replyer}, function(result){
   				alert(result);
   				$("input[name='replyer']").val("");
   				$("textarea[name='reply']").val("");
   				$(".register-form").hide();
   	   			$(".register").show();
   				pageNum = 1;
   				showList(pageNum);
   			});
   		});
   		
   		function showReplyPage(replyCnt){
   			var str = "";
   			var endNum = Math.ceil(pageNum / 10.0) * 10
   			var startNum = endNum - 9;
   			var realEnd = Math.ceil(replyCnt / 10.0)
   			var divTag = $(".paging");   			
   			
   			if(endNum > realEnd){
   				endNum = realEnd;
   			}
   			
   			var prev = startNum != 1;
   			var next = endNum * 10 < replyCnt;
   			
   			if(matchMedia("screen and (max-width:918px)").matches){
   				//918px보다 작을 때
   				if(pageNum > 1){
   					str += "<a class='changePage' href='" + (pageNum - 1) + "'><code>&lt;</code></a>";
   				}
   				str += "<code>" + pageNum + "</code>";
   				if(pageNum < realEnd){
   					str += "<a class='changePage' href='" + (pageNum + 1) + "'><code>&gt;</code></a>";
   				}
   			}else{
   				//918px 이상일 때
   				if(prev){
   					str += "<a class='changePage' href='" + (startNum - 1) + "'><code>&lt;</code></a>";
   				}
   				for(let i=startNum; i<=endNum; i++){
   					if(i == pageNum){
   						str += "<code>" + i + "</code>";
   						continue;
   					}
   					str += "<a class='changePage' href='" + i + "'><code>" + i + "</code></a>";
   				}
   				if(next){
   					str += "<a class='changePage' href='" + (endNum + 1) + "'><code>&gt;</code></a>";
   				}
   			}
   			
   			divTag.html(str);
   		}
   		$(".paging").on("click", "a.changePage", function(e){
   			e.preventDefault();
   			pageNum = parseInt($(this).attr("href"));
   			showList(pageNum);
   		})
   		
   		
   		function showList(page){
   			var replyUL = $(".replies");
   			replyService.getList({bno:bno, page:page||1},
   					function(replyCnt, list){
   						var str = "";
   						if(list == null || list.length == 0){
   							//등록된 댓글이 없습니다.
   							if(pageNum > 1) {
   								pageNum -= 1;
   								showList(pageNum);
   							}
   							replyUL.html("등록된 댓글이 없습니다.");
   							return;
   						}
   						for(let i=0, len=list.length; i<len; i++){
   							str += "<li data-rno='" + list[i].rno + "'>";
   							str += "<strong>" + list[i].replyer + "</strong>";
   							str += "<p class='reply" + list[i].rno + "'>" + list[i].reply + "</p>";
   							str += "<div style='text-align:right;'>";
   							str += "<strong>" + replyService.displayTime(list[i].replyDate);
   							if(list[i].replyDate != list[i].updateDate){
   								str += "<br>수정된 날짜 " + replyService.displayTime(list[i].updateDate);
   							}
   							str += "</strong><br><a class='modify' href='" + list[i].rno + "'>수정</a>";
   							str += "<a class='finish' href='" + list[i].rno + "' style='display:none;'>수정완료</a>";
   							str += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
   							str += "<a class='remove' href='" + list[i].rno + "'>삭제</a>";
   							str += "</div><div class='line'></div></li>";
   						}
   						replyUL.html(str);
   						showReplyPage(replyCnt);
   			});
   		}
   		
   		//댓글 삭제
   		$(".replies").on("click", "a.remove", function(e){
   			e.preventDefault();
   			var rnoValue = $(this).attr("href");
   			replyService.remove(rnoValue, 
   					function(result){
   						alert(result);
   						showList(pageNum);
   				});
   		});
   		
   		var check = false;
   		//댓글 수정
   		$(".replies").on("click", "a.modify", function(e){
   			//1. p태그를 textarea로 변경(기존 p태그의 내용을 textarea로 옮겨야 한다)
   			//2. 수정완료 버튼
   			e.preventDefault();
   			
   			if(check){alert("수정중인 댓글이 있습니다."); return;}
   			
   			var rnoValue = $(this).attr("href");
   			var replyTag = $(".reply" + rnoValue);
   			replyTag.html("<textarea class='" + rnoValue + "'>" + replyTag.text() + "</textarea>");
   			$(this).hide();
   			
   			var finishs = $(".finish");
   			for(let i=0; i<finishs.length; i++){
   				if($(finishs[i]).attr("href") == rnoValue){
   					$(finishs[i]).show();
   					check = true;
   					break;
   				}
   			}   			
   		});
   		
   		//수정 완료
   		$(".replies").on("click", "a.finish", function(e){
   			e.preventDefault();
   			
   			var rnoValue = $(this).attr("href");
   			var newReply = $("." + rnoValue).val();
   			
   			if(newReply == ""){return;}
   			
   			replyService.update({rno:rnoValue, reply:newReply},
   					function(result){
   						alert(result);
   						check = false;
   						showList(pageNum);
   			});
   		});
   	});
   </script>
</html>











