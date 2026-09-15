package com.accasw.ristoranteApp.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController extends BaseController {

	@GetMapping("/test")
	public Map<String, String> test() {
		return Map.of("status", "ok", "service", "ristoranteApp");
	}
}