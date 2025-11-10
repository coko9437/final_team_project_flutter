// lib/models/youtube_recipe.dart

/// 유튜브 레시피 DTO
class YoutubeRecipe {
final String title;
final String videoId;
final String? url;

YoutubeRecipe({
required this.title,
required this.videoId,
this.url,
});

factory YoutubeRecipe.fromJson(Map<String, dynamic> json) {
return YoutubeRecipe(
title: json['title'] as String,
videoId: json['videoId'] as String,
url: json['url'] as String?,
);
}

Map<String, dynamic> toMap() {
return {
'title': title,
'videoId': videoId,
'url': url ?? 'https://www.youtube.com/watch?v=$videoId',
};
}
}