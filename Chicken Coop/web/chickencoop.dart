
import 'dart:html';
import 'dart:json';
import 'dart:math';
import 'dart:async';

/**
 * The entry point to the application.
 */
void main() 
{  
 new Timer.repeating(1000, OpenData);
}


void OpenData(Timer T)
{
  var request = new HttpRequest.get("data.json", onSuccess);
}

void onSuccess(HttpRequest req) 
{
  var Temperature = query("#Temp");
  var DoorStatus = query("#Door");
  var Time = query("#Time");
  CanvasElement canvas =  query("#container");
  
  Map data = parse(req.responseText);
  
  Temperature.text = "Temperature: ${data["Temperature"]} Degrees";
  
  if(data["Door Open"])
  {
    DoorStatus.text ="Door: Open";
  }
  else
  {
    DoorStatus.text ="Door: Closed";
  }
  
  Time.text = "Uptime: ${data["Time"]} Seconds";
  
  window.requestLayoutFrame(() 
  {
    var width = canvas.width/2;
    var height = canvas.height;
    var radius = width * 0.90;
    var bottom = height - width;
    var top = width;
    var percent = (data["Water Level"]/100);
         
    CanvasRenderingContext2D context = canvas.context2d;
    
    context.clearRect(0, 0, canvas.width, canvas.height);
    
    context..lineWidth = 2.0
    ..fillStyle = "blue"
    ..strokeStyle = "black"
    ..beginPath()
    ..arc(width, bottom, radius, PI, 2*PI, true);
    
    if(percent != 0.0)
    {
      context.fill();
    }
    
    context.arc(width, top, radius, 0, PI, true);
    
    if(percent == 1.0)
    {
      context.fill();
    }

    context.closePath();
    context..stroke();
    
    context.fillRect(width-radius, bottom, radius*2, -((bottom - top)*percent));
    if(percent > .50)
    {
     context.fillStyle = "white";
     context.textBaseline = "top";
    }
    else
    {
      context.fillStyle = "blue";
      context.textBaseline = "bottom";
    }
    context.font = "15px Lucida Console";
    var level_string = "${((percent * 100).toInt()).toString()}%";

    context.fillText(level_string, width-radius+2, height/2);    
    
  });
  
  
}