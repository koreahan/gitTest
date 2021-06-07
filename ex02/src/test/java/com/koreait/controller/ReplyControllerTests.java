package com.koreait.controller;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonStringFormatVisitor;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.koreait.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration	//Servlet의 ServletContext를 이용하기 위함
@ContextConfiguration({
	"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
@Log4j
public class ReplyControllerTests {
	@Setter(onMethod_=@Autowired)
	private WebApplicationContext wac;
	
	//가짜MVC
	//마치 브라우저에서 사용하는 것처럼 만들어서 Controller를 실행해 볼 수 있다.
	private MockMvc mockMvc;
	
	@Before	//모든 테스트 전에 매번 실행된다.
	public void setup() {
		//WebApplicationContext를 통해 ServletContext를 빌드한다.
		this.mockMvc = MockMvcBuilders.webAppContextSetup(wac).build(); 
	}
	
	@Test
	public void testPatch() throws Exception {
		String json = "{\"reply\":\"Patch테스트 성공\"}";
		MvcResult result = mockMvc.perform(patch("/replies/{rno}", 21).contentType(MediaType.APPLICATION_JSON_UTF8_VALUE).content(json))
				.andExpect(status().isOk()).andExpect(content().string(equalTo(json))).andReturn();
		
		log.info(result.getResponse().getContentAsString());
	}
}



























