aPackageInfo = [
	:name = "ringsubprocess",
	:description = "A powerful subprocess management extension for the Ring programming language that provides a simple interface for creating and managing system processes.",
	:folder = "ringsubprocess",
	:developer = "Azzeddine Remmal",
	:email = "Azzeddine.Remmal@gmail.com",
	:license = "MIT License",
	:version = "1.0.0",
	:ringversion = "1.22",
	:versions = 	[
		[
			:version = "1.0.0",
			:branch = "master"
		]
	],
	:libs = 	[
		[
			:name = "",
			:version = "",
			:providerusername = ""
		]
	],
	:files = 	[
		"main.ring",
		"extensions/ringsubprocess/example/example.ring",
		"extensions/ringsubprocess/example/ffmpeg_processor.ring",
		"extensions/ringsubprocess/example/gemini_chat.ring",
		"extensions/ringsubprocess/example/lesson_stdin.ring",
		"extensions/ringsubprocess/example/quotes_example.ring",
		"extensions/ringsubprocess/example/system_info.ring",
		"extensions/ringsubprocess/example/test.ring",
		"extensions/ringsubprocess/example/test2.ring",
		"extensions/ringsubprocess/example/weather_example.ring",
		"extensions/ringsubprocess/example/youtube_example.ring",
		"extensions/ringsubprocess/README.md",
		"extensions/ringsubprocess/ring_subprocess.c",
		"extensions/ringsubprocess/ring_subprocess.h",
		"extensions/ringsubprocess/subprocess.ring",
		"README.md",
		"setup.ring",
		"uninstall.ring"
	],
	:ringfolderfiles = [
		"bin/load/subprocess.ring"
	],
	:windowsfiles = [
		"extensions/ringsubprocess/buildvc_x64.bat",
		"extensions/ringsubprocess/ring_subprocess.exp",
		"extensions/ringsubprocess/ring_subprocess.ilk",
		"extensions/ringsubprocess/ring_subprocess.lib",
		"extensions/ringsubprocess/ring_subprocess.pdb"
	],
	:setup = "ring setup.ring",
	:remove = "ring uninstall.ring"
]
