class Movie{
  int id;
  String _title;
  String _year;
  String _rating;
  String _description;
  String _poster;

  Movie(
      this._title,
      this._year,
      this._rating,
      this._description,
      this._poster
      );

  Movie.map(dynamic obj){
    this._title = obj["title"];
    this._year = obj["year"];
    this._rating = obj["rating"];
    this._description = obj["description"];
    this._poster = obj["poster"];

  }

  String get description => _description;

  String get rating => _rating;

  String get year => _year;

  String get title => _title;

  String get poster => _poster;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map["title"] = _title;
    map["year"] = _year;
    map["rating"] = _rating;
    map["description"] = _description;
    map["poster"] = _poster;

    return map;
  }

  void setMovieId(int id){
    this.id = id;
  }
}