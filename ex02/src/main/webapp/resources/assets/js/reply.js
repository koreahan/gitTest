/**
 * Javascript reply ajax module
 */

var replyService = (function(){
	//댓글 추가
	function add(reply, callback, error){
		console.log("add reply..........");
		
		$.ajax({
			type: "post",
			url: "/replies/new",
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, err){
				if(error){
					error(err);
				}
			}
		});
	}
	
	//댓글 목록
	function getList(param, callback, error){
		console.info("getList.........");
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json", 
				function(data){
					if(callback){
						callback(data.replyCnt, data.list);
					}
				})
		.fail(function(xhr, status, err){
			if(error){
				error(err);
			}
		})
		
	}
	
	//댓글 삭제
	function remove(rno, callback, error){
		console.info("remove...........");
		
		$.ajax({
			type: "delete",
			url: "/replies/" + rno,
			success: function(result){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, err){
				if(error){
					error(err);
				}
			}
		});
	}
	
	//댓글 수정
	function update(reply, callback, error){
		console.log("update : " + reply.rno);
		
		$.ajax({
			type: "PUT",
			url: "/replies/" + reply.rno,
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, err){
				if(error){
					error(err);
				}
			}
		});
	}
	
	//댓글 조회
	function get(rno, callback, error){
		$.get("/replies/" + rno + ".json", function(result){if(callback) callback(result);})
		.fail(function(xhr, status, err){if(error) error(err);})
	}
	
	//시간 처리
	function displayTime(timeValue){
		var today = new Date();
		var replyTime = new Date(timeValue);
		var gap = today.getTime() - replyTime.getTime();
		
		if(gap < 24 * 60 * 60 * 1000){
			//시분초
			var hh = replyTime.getHours();
			var mi = replyTime.getMinutes();
			var ss = replyTime.getSeconds();
			
			return [(hh > 9 ? '' : '0') + hh, (mi > 9 ? '' : '0') + mi, (ss > 9 ? '' : '0') + ss].join(' : ');
		}else{
			//년월일
			var yy = replyTime.getFullYear();
			var mm = replyTime.getMonth() + 1;
			var dd = replyTime.getDate();
			
			return [yy, (mm > 9 ? '' : '0') + mm, (dd > 9 ? '' : '0') + dd].join(' - ');
		}
	}
	
	return {add : add, getList : getList, remove : remove, update : update, get : get, displayTime : displayTime};
})();




















