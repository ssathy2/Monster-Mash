
class Connection {

  MySQL msql;
  /* public Connection {
   
   String user = "root";
   String passwd = "root";
   String database = "p2";
   msql = new MySQL( this, "localhost", database, user, passwd );
   }*/
  ArrayList<String> getGenres(MySQL msql, String[] genreList, int yearStart, int yearEnd) {
    ArrayList<String> a = new ArrayList<String>();
    if (genreList.length == 1) {
      String genreString = genreList[0];
      if ( msql.connect() )
      {
        msql.query("select movie.titleMovie from movie,genre where movie.idMovie = genre.idMovie and movie.idMovie in (select distinct(idMovie) from genre where genreMovie = '"+genreString+"' ) and movie.yearMovie in ('"+yearStart+"','"+yearEnd+"') order by genre.idMovie limit 0,10000");
        while (msql.next ()) {
          a.add(msql.getString("movie.titleMovie"));
        }
        return a ;
      }
      else {
        return a;
      }
    }
    else {
      String genreString = "";
      int n=1;
      // have to make a string for query which shows 
      for (String s : genreList)
      {
        if (n==1) {
          genreString = "'"+s+"'";
          n++;
        }
        else {
          genreString = genreString + "," + "'"+s+"'";
        }
      }
      println(genreString);
      if ( msql.connect() )
      {
        msql.query("select movie.titleMovie from movie,genre where movie.idMovie = genre.idMovie and movie.idMovie in (select idMovie from genre where genreMovie in ("+genreString+") ) and movie.yearMovie in ('"+yearStart+"','"+yearEnd+"') order by genre.idMovie limit 0,10000");
        while (msql.next ()) {
          a.add(msql.getString("movie.titleMovie"));
        }
        return a ;
      }
      else {
        return a;
      }
      // return a;
    }
  }
}

