class SSEModel {
  String? id;
  String? event;
  String? data;

  SSEModel({
    this.data,
    this.event,
    this.id,
  });

  SSEModel.fromString(String data) {
    id = data.split("\n")[0].split('id:')[1];
    event = data.split("\n")[1].split('event:')[1];
    this.data = data.split("\n")[2].split('data:')[1];
  }
}
