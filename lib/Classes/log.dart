class LogEvent
{
  String event_time;
  String event_name;
  String event_image_path;
  var u_key;
  bool has_image;
  LogEvent(this.event_time, this.event_name, this.u_key, this.has_image, this.event_image_path);

  static List<LogEvent> LogEvents = new List<LogEvent>();

}