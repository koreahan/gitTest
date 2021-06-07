package com.koreait.controller;

import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.koreait.domain.Criteria;
import com.koreait.domain.ReplyPageDTO;
import com.koreait.domain.ReplyVO;
import com.koreait.service.ReplyService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController	//각 메소드의 리턴은 ViewResolver로 가지 않는다.
@Log4j
public class ReplyController {
	@Setter(onMethod_=@Autowired)
	private ReplyService service;
	//댓글 등록
	//브라우저에서 JSON타입으로 데이터를 전송하고 서버에서는 댓글의 처리 결과에 따라 문자열로 결과를 리턴한다.
	//consumes : Ajax를 통해 전달받은 데이터의 타입
	//produces : Ajax의 success:function(result)에 있는 result로 전달할 데이터의 타입
	//@ResponseBody : @Controller에서 Body를 응답하기 위해서(viewResolver를 가지 않게 하기 위해서) 사용된다.
	
	//문자열을 전달할 때 한글이 깨지지 않게 하기 위해서는 text/plain; charset=utf-8를 작성한다.
	
	@PostMapping(value="/new", consumes="application/json", produces="text/plain; charset=utf-8")
	//ResponseEntity : 서버의 상태코드, 응답 메세지등을 담을 수 있는 타입.
	//@RequestBody를 적용하여 JSON데이터를 ReplyVO타입으로 변환하도록 지정한다.
	public ResponseEntity<String> create(@RequestBody ReplyVO reply) throws UnsupportedEncodingException{
		int insertCnt = 0;
		log.info("ReplyVO : " + reply);
		insertCnt = service.register(reply);
		log.info("Reply INSERT COUNT : " + insertCnt);
		return insertCnt == 1 ? new ResponseEntity<>(new String("댓글 등록 성공".getBytes(), "UTF-8"), HttpStatus.OK) /*200 OK*/:
			new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); /*500 Server Error*/
	}
	
	//게시글 댓글 전체 조회
	@GetMapping(value="/pages/{bno}/{page}", produces= {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("bno") Long bno, @PathVariable("page") int page){
		log.info("getList..........");
		Criteria cri = new Criteria(page, 10);
		log.info(cri);
		
		return new ResponseEntity<ReplyPageDTO>(service.getListWithPaging(cri, bno), HttpStatus.OK);
	}
	
	//댓글 조회
	@GetMapping(value="/{rno}", produces= {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("get : " + rno);
		return new ResponseEntity<ReplyVO>(service.get(rno), HttpStatus.OK);
	}
	
	//댓글 수정
	//PUT : 자원 전체 수정, 자원 내 모든 필드를 전달해야 함, 일부만 전달할 경우 전달되지 않은 필드는 모두 초기화 처리가 된다.
	//PATCH : 자원 일부 수정, 수정할 필드만 전송
	@RequestMapping(method= {RequestMethod.PUT, RequestMethod.PATCH}, value="/{rno}", consumes="application/json", produces=MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> modify(@RequestBody ReplyVO reply, @PathVariable("rno") Long rno){
		reply.setRno(rno);
		int modifyCnt = 0;
		
		log.info("rno : " + rno);
		modifyCnt = service.modify(reply);
		
		return modifyCnt == 1 ? new ResponseEntity<String>("success", HttpStatus.OK) :
			new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	//댓글 삭제
	@DeleteMapping(value="/{rno}", produces=MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		log.info("remove : " + rno);
		return service.remove(rno) == 1 ? new ResponseEntity<>("success", HttpStatus.OK) :
			new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}






























