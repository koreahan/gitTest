package com.koreait.mapper;

import java.util.List;

import com.koreait.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public void insert(BoardAttachVO vo);
	public void delete(String uuid);
	public void deleteAll(Long bno);
	public List<BoardAttachVO> findByBno(Long bno);
	public List<BoardAttachVO> getOldFiles();
}
