package com.koreait.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.koreait.domain.BoardAttachVO;
import com.koreait.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class FileCheckTask {
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper attachMapper;
	
	//cron="0 * * * * *" : 매 분 0초 마다
	@Scheduled(cron="0 * * * * *")
	public void checkFiles() throws Exception{
		log.warn("---------------------------------");
		log.warn("File check Task run...........");
		log.warn("---------------------------------");
		
		//어제 첨부파일 목록
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//람다식으로 진행.
		//반복 시 저장된 데이터를 List 타입으로 변경할 때 사용된다.
		//stream().map() : map안에 있는 람다식을 통해 반복된 데이터를 Stream(순서가 있는)형태로 저장해 놓는다.
		List<Path> fileListPaths = fileList.stream().map(vo ->
			Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
			.collect(Collectors.toList());
		//순서가 있는 Stream형태 객체는 collect메소드를 통하여 Collection Framework타입으로 변경시켜 사용이 가능하다.
		
		//이미지 파일을 filter로 검사 후 썸네일 경로도 fileListPaths에 저장
		//filter는 해당 객체 안에 있는 boolean타입을 통하여 true일 때에만 뒤에 연결된 Stream으로 넘어가도록 해준다.
		fileList.stream().filter(vo -> vo.isFileType()).map(vo -> //이미지 파일 객체면 vo에 담는다.
		Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName())) //원본 경로에 s_ 추가
		.forEach(p -> fileListPaths.add(p));//어제 올린 첨부파일 중 이미지 파일들은 fileListPAths에 s_경로까지 추가해준다.
		
		fileListPaths.forEach(log::warn);
		
		//어제 업로드 폴더 경로
		File targetDir = Paths.get("C:\\upload", getFolderYesterday()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> !fileListPaths.contains(file.toPath()));
		
		for (File file : removeFiles) {
			log.warn(file.getPath() + " deleted");
			file.delete();
		}
	}
	
	private String getFolderYesterday() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		
		return sdf.format(cal.getTime()).replace("-", File.separator);
	}
	
}

















