package com.koreait.service;

import java.util.List;

import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreait.domain.BoardAttachVO;
import com.koreait.domain.BoardVO;
import com.koreait.domain.Criteria;
import com.koreait.mapper.BoardAttachMapper;
import com.koreait.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class BoardServiceImple implements BoardService {
	private BoardMapper mapper;
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(@Nullable BoardVO board) {
		log.info("register........." + board);
		mapper.insertSelectKey_bno(board);
		
		List<BoardAttachVO> attachList = board.getAttachList();
		log.info("attachList : " + attachList);
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		attachList.forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get............" + bno);
		return mapper.read(bno);
	}
	
	/*
	 * 3개 이상의 DML을 사용한 트랜젝션이 있다면,
	 * ROLLBACK의 우선순위가 가장 빠른 것을 가장 먼저 사용해주어야 한다.
	 * 만약 우선순위에 맞춰서 작성하지 않게 되면 전체 ROLLBACK이 된다.
	 */
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify............" + board);
		//첨부파일이 게시글보다 우선순위가 높다(cardinality)
		//첨부파일 작업이 모두 잘 삭제되고, 게시글의 내용이 수정된다면,
		//첨부파일 추가 시 충돌이 발생되지 않는다.
		//만약 이 부분을 지키지 않을 경우 다른 트랜젝션에 의해 롤백될 수 있다(방지할 수 있지만, 안전하게 설계).
		
		//*테이블 2개 이상
		
		//1순위 : 전체 삭제
		attachMapper.deleteAll(board.getBno());
		//2순위 : 전체 수정(2개 이상)
		boolean modifyResult = mapper.update(board) == 1;
		
		//3순위 : DML
		if(modifyResult && board.getAttachList() != null) {
			if(board.getAttachList().size() != 0) {
				board.getAttachList().forEach(attach -> {
					attach.setBno(board.getBno());
					attachMapper.insert(attach);
				});
			}
		}
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove............" + bno);
		attachMapper.deleteAll(bno);
		return mapper.delete(bno) == 1;
	}

	@Override
	public List<BoardVO> getList() {
		log.info("getList............");
		return mapper.getList();
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList with criteria............" + cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		return mapper.getTotal(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}
}











