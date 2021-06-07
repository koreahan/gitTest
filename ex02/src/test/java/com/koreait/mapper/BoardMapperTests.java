package com.koreait.mapper;

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
public class BoardMapperTests {
	@Setter(onMethod_=@Autowired)
	private BoardMapper mapper;

//	@Test
//	public void testGetListWithPaging() {
//		Criteria cri = new Criteria(2, 20);
////		cri.setPageNum(2);
//		mapper.getListWithPaging(cri).forEach(board -> log.info(board.getBno()));
//	}
	
//	@Test
//	public void testUpdate() {
//		BoardVO board = new BoardVO();
//		board.setBno(3L);
//		board.setTitle("수정된 글 제목");
//		board.setContent("수정된 글 내용");
//		board.setWriter("admin");
//		
//		log.info("UPDATE COUNT : " + mapper.update(board));
//	}
	
	@Test
	public void testDelete() {
		log.info("DELETE COUNT : " + mapper.delete(3145905L));
//		log.info("DELETE COUNT : " + mapper.delete(100L));
	}
	
//	@Test
//	public void testRead() {
//		Long bno = 2L;
//		log.info(mapper.read(bno));
//	}
	
//	@Test
//	public void testInsertSelectKey_bno() {
//		BoardVO board = new BoardVO();
//		board.setTitle("새로 작성한 글 제목2");
//		board.setContent("새로 작성한 글 내용2");
//		board.setWriter("newbie2");
//		
//		mapper.insertSelectKey_bno(board);
//		log.info(board);
//	}
//	@Test
//	public void testInsert() {
//		//의존성은 해당 클래스의 필드에만 적용되므로
//		//메소드 안에서는 new로 할당한다.
//		BoardVO board = new BoardVO();
//		board.setTitle("새로 작성한 글 제목");
//		board.setContent("새로 작성한 글 내용");
//		board.setWriter("newbie");
//		
//		mapper.insert(board);
//		log.info(board);
//	}
	
//	@Test
//	public void testGetList() {
//		mapper.getList().forEach(board -> log.info(board));
//	}
}























