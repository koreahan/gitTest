package com.koreait.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.koreait.domain.BoardVO;
import com.koreait.domain.Criteria;

public interface BoardMapper {
	//@Select("SELECT * FROM TBL_BOARD WHERE BNO > 0")
	public List<BoardVO> getList();
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int getTotal(Criteria cri);
	
	public void insert(BoardVO board);
	
	public void insertSelectKey_bno(BoardVO board);
	
	//read() 선언 후 테스트 : 게시글 상세보기
	public BoardVO read(Long bno);
	
	//delete() 선언 후 테스트 : 게시글 삭제
	//게시글 삭제 시 1이상의 값 리턴, 없으면 0 리턴
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}






















