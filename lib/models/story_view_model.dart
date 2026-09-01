class StoryViewModel{
  final String name;
  final String img;

  StoryViewModel({required this.name, required this.img});

}

List<Map> _storyData = [
  {"aziz": "https://api.dicebear.com/9.x/adventurer/png?seed=aziz"},
  {"jasur": "https://api.dicebear.com/9.x/adventurer/png?seed=jasur"},
  {"sardor": "https://api.dicebear.com/9.x/adventurer/png?seed=sardor"},
  {"bekzod": "https://api.dicebear.com/9.x/adventurer/png?seed=bekzod"},
  {"otabek": "https://api.dicebear.com/9.x/adventurer/png?seed=otabek"},
  {"sherzod": "https://api.dicebear.com/9.x/adventurer/png?seed=sherzod"},
  {"farrux": "https://api.dicebear.com/9.x/adventurer/png?seed=farrux"},
  {"rustam": "https://api.dicebear.com/9.x/adventurer/png?seed=rustam"},
  {"dilnoza": "https://api.dicebear.com/9.x/adventurer/png?seed=dilnoza"},
  {"malika": "https://api.dicebear.com/9.x/adventurer/png?seed=malika"},
];



List<StoryViewModel>StoryViewData = [
  StoryViewModel(name: _storyData[0].keys.toList()[0],img: _storyData[0].values.toList()[0]),
  StoryViewModel(name: _storyData[1].keys.toList()[0],img: _storyData[1].values.toList()[0]),
  StoryViewModel(name: _storyData[2].keys.toList()[0],img: _storyData[2].values.toList()[0]),
  StoryViewModel(name: _storyData[3].keys.toList()[0],img: _storyData[3].values.toList()[0]),
  StoryViewModel(name: _storyData[4].keys.toList()[0],img: _storyData[4].values.toList()[0]),
  StoryViewModel(name: _storyData[5].keys.toList()[0],img: _storyData[5].values.toList()[0]),
  StoryViewModel(name: _storyData[6].keys.toList()[0],img: _storyData[6].values.toList()[0]),
  StoryViewModel(name: _storyData[7].keys.toList()[0],img: _storyData[7].values.toList()[0]),
  StoryViewModel(name: _storyData[8].keys.toList()[0],img: _storyData[8].values.toList()[0]),
  StoryViewModel(name: _storyData[9].keys.toList()[0],img: _storyData[9].values.toList()[0]),

];

