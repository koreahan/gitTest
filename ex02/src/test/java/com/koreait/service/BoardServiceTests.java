package com.koreait.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.koreait.domain.BoardVO;
import com.koreait.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class) //테스트 코드가 스프링을 실행
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")//지정된 클래스나 문자열을 이용해서 필요한 객체들을 스프링 내에 객체로 등록
@Log4j
public class BoardServiceTests {
	@Setter(onMethod_=@Autowired)
	private BoardService service;
	
	@Test
	public void testGetList() {
		service.getList(new Criteria(1, 30)).forEach(board -> log.info(board));
	}
	
//	@Test
//	public void testRegister() {
//		BoardVO board = new BoardVO();
//		board.setTitle("추가한 글 제목");
//		board.setContent("추가한 글 내용");
//		board.setWriter("user123");
//		service.register(board);
//		
//		log.info("생성된 게시글 번호 : " + board.getBno());
//	}
	
//	@Test
//	public void testGetList() {
//		service.getList().forEach(board -> log.info(board));
//	}
	
//	@Test
//	public void testGet() {
//		log.info(service.get(2L));
//	}
	
//	@Test
//	public void testModify() {
//		BoardVO board = service.get(100L);
//		if(board == null) {return;}
//		board.setTitle("수정된 제목");
//		log.info("MODIFY RESULT : " + service.modify(board));
//	}
	
//	@Test
//	public void testRemove() {
//		Long bno = 1L;
//		//만약 해당 게시글이 존재하지 않으면 remove 하지 않도록 막아주기
//		if(service.get(bno) == null) {return;}
//		log.info("REMOVE RESULT : " + service.remove(bno));
//		
//	}
	
//	@Test
//	public void testExist() {
//		assertNotNull(service);
//		log.info(service);
//	}
}





















