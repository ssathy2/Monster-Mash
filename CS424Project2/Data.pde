 import de.bezier.data.sql.*;

Connection connectionObject = new Connection();
MySQL msql;
 void setup(){
    
    
    String user = "root";
    String passwd = "root";
    String database = "p2";
    msql = new MySQL( this, "localhost", database, user, passwd );
    String[] genreList = {"Comedy","Drama"};    
    int startYear = 2001;
    int endYear = 2010;
    //this will fetch you an arraylist of all unique movies having genres in the genreList from startYear to endYear
    //take care not to send an empty genreList
    ArrayList<String> a = connectionObject.getGenres(msql,genreList,startYear,endYear);
    //you can iterate the arraylist as and how you want
    for (String stringElement : a){
      println(stringElement);
    }
    //get size and other functions that the java class arrayList exposes
    println(a.size());
}
void draw()
{
      // i know this is not really a visual sketch ...
}



 
