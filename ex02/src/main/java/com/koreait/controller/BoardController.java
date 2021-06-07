package com.koreait.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.koreait.domain.BoardAttachVO;
import com.koreait.domain.BoardVO;
import com.koreait.domain.Criteria;
import com.koreait.domain.PageDTO;
import com.koreait.service.BoardService;
import com.koreait.service.BoardServiceImple;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	private BoardService service;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list");
		model.addAttribute("list", service.getList(cri));
		//getTotal(Criteria) : type과 keyword가 전달되면 검색된 게시글의 건수이며, 검색하지 않으면 전체 게시글의 건수이다.
		model.addAttribute("pageMaker", new PageDTO(cri, service.getTotal(cri)));
	}
	
	@GetMapping("/register")
	public void register(@ModelAttribute("cri") Criteria cri) {log.info(cri);}
	
	@PostMapping("/register")
	public String register(BoardVO board, /*Model model*/ RedirectAttributes rttr) {
		log.info("register : " + board);
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(log::info);
		}
		service.register(board);
//		model.addAttribute("result", board.getBno());
		//새롭게 등록된 번호를 .jsp에 전달하기 위해서는
		//request객체에 담아야 한다. 하지만 redirect방식으로 전송할 때에는
		//request가 초기화 된다. 따라서 세션에 있는 Flash영역에 담아놓고
		//초기화된 request객s체에 전달해주면 결과값을 안전하게 이동시킬 수 있다.
		//이 때 RedirectAttributes를 이용한다.
		rttr.addFlashAttribute("result", board.getBno());
		
		//'redirect:' 접두어를 사용하면 스프링 MVC가 내부적으로
		//response.sendRedirect()를 처리해준다.
		return "redirect:/board/list";
	}
	
	//조회 처리와 테스트 구현
	@GetMapping({"/get", "/modify"})
	//RequestParam은 객체와 일반 변수가 동시에 있을 때 분리하기 위해 작성한다.
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		model.addAttribute("board", service.get(bno));
	}
	
	//※ 수정과 삭제는 성공 시 result에 success를 담아서 view에 전달하기
	//수정 처리와 테스트 구현
	@PostMapping("/modify")
	public String modify(BoardVO board, Criteria cri, RedirectAttributes rttr) {
		log.info("modify : " + board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		//Flash는 세션의 남용을 방지하고자 1개의 파라미터만 전달할 수 있다.
		//따라서 여러 개를 전달해야 할 때에는 컬렉션에 담아서 넘기거나
		//URL에 붙여서 전달하는 addAttribute()방식을 사용해야 한다.
		
//		rttr.addFlashAttribute("pageNum", cri.getPageNum());
//		rttr.addFlashAttribute("amount", cri.getAmount());
		
		//항상 컨트롤러에 있는 클래스타입의 매개변수는 생성자를 통해서 파라미터 값으로 초기화 한다.
		//만약 전달받은 파라미터 값에 매핑되는 생성자가 없다면 값을 전달받을 수 없다.
//		rttr.addFlashAttribute("cri", cri);
//		rttr.addAttribute("cri", cri);
		
		//따라서 반드시 해당 객체의 생성자에 전달할 필드명과 일치하도록 설정해주어야 한다. 
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("keyword", cri.getKeyword());
		rttr.addAttribute("type", cri.getType());
		return "redirect:/board/list";
	}
	//삭제 처리와 테스트 구현
	@GetMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr) {
		log.info("remove : " + bno);
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		if(service.remove(bno)) {//DB에서 첨부파일 전체삭제, 게시글 삭제(댓글 삭제)
			deleteFiles(attachList); //경로에 있는 해당 게시글 첨부 파일 전체 삭제
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("keyword", cri.getKeyword());
		rttr.addAttribute("type", cri.getType());
		return "redirect:/board/list";
	}
	
	@GetMapping(value="/getAttachList", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList :" + bno);
		return new ResponseEntity<List<BoardAttachVO>>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files.......");
		log.info(attachList);

		attachList.forEach(attach -> {
			//1. File객체에 담아서 delete()사용
			//2. Files.delete(Path) : 해당 경로에 있는 파일을 삭제한다.
			
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				Files.delete(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbnail = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_" + attach.getFileName());
					Files.delete(thumbnail);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		});
	}
}





















