import de.bezier.data.sql.*;

class DatabaseAdapter {
  PApplet parent;
  MySQL msql;
  String user;
  String pass;
  String database;
  String server;
 
  public DatabaseAdapter(PApplet p, String username, String password, String db, String s) {
   user = username;
   pass = password;
   database = db;
   parent = p;
   server = s;
   msql = new MySQL(parent, server, database, user, pass);
  }

  private String generateGenreQueryString(String[] genreList) {
    String genreString = "";
    int n = 1;
    for (String s : genreList) {
        if (n==1) {
          genreString = "'"+s+"'";
          n++;
        }
        else {
          genreString = genreString + "," + "'"+s+"'";
        }
     }
    return genreString;
  }
  
  public String[] getAllCountries() {
    String[] ret = new String[202];
    if(msql.connect()) {
      msql.query("select Distinct country.countryMovie from country");
      int i = 0;
      while (msql.next()) {
        ret[i] = msql.getString("country.countryMovie");
        i++; 
      }
    }  
    return ret;
  }
  
  public HashMap<Integer, Integer> getNumberMoviesPerYear(String genre[], String country, int yearStart, int yearEnd) {
   HashMap<Integer, Integer> retMap = new HashMap<Integer, Integer>();
    int j = 0;
    if(msql.connect()) {
      String genreString = generateGenreQueryString(genre);
      
      msql.query("select yearMovie from movie where idMovie in (select idMovie from country where idMovie in (select idMovie from genre where genreMovie in ("+genreString+"))and countryMovie = '"+country+"') and yearMovie between "+yearStart+" and "+yearEnd+"");
      
      // kinda hacky and ovekill and slow but yea  
      while(msql.next()) {
        int yearRes = msql.getInt("yearMovie");
        if(!retMap.containsKey(yearRes)) {
          retMap.put(yearRes, 0); 
        }
        else {
          retMap.put(yearRes, retMap.get(yearRes) + 1);
        }
      }  
    }
    return cleanedUpMap(retMap);    
  }
  
  public HashMap<Integer, Integer> getNumberMoviesPerYear(String genre, int yearStart, int yearEnd) {
    HashMap<Integer, Integer> retMap = new HashMap<Integer, Integer>();
    int j = 0;
    if(msql.connect()) {
      msql.query("select movie.yearMovie from movie,genre where movie.idMovie = genre.idMovie and movie.idMovie in (select idMovie from genre where genreMovie = '"+genre+"' ) and movie.yearMovie between '"+yearStart+"' and '"+yearEnd+"' order by genre.idMovie limit 0,1000000");
           
      // kinda hacky and ovekill and slow but yea  
      while(msql.next()) {
        int yearRes = msql.getInt("movie.yearMovie");
        if(!retMap.containsKey(yearRes)) {
          retMap.put(yearRes, 0); 
        }
        else {
          retMap.put(yearRes, retMap.get(yearRes) + 1);
        }
      }  
    }
    return cleanedUpMap(retMap);
  }
  
  // helper method that iterates over the map and puts any zeros where there's nulls
  private HashMap<Integer, Integer> cleanedUpMap(HashMap<Integer, Integer> p){
    for(int i = 1890; i < 2012; i++){
      if(p.get(i) == null) {
        p.put(i, 0);
      } 
    }
    return p;
  }
  
  ArrayList<String> getMoviesWithGenres(String[] genreList, int yearStart, int yearEnd) {
    ArrayList<String> a = new ArrayList<String>();
    if (genreList.length == 1) {
      String genreString = genreList[0];
      if ( msql.connect() )
      {
        msql.query("select movie.titleMovie from movie,genre where movie.idMovie = genre.idMovie and movie.idMovie in (select distinct(idMovie) from genre where genreMovie = '"+genreString+"' ) and movie.yearMovie between '"+yearStart+"' and '"+yearEnd+"' order by genre.idMovie limit 0,10000000");
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
        msql.query("select movie.titleMovie from movie,genre where movie.idMovie = genre.idMovie and movie.idMovie in (select idMovie from genre where genreMovie in ("+genreString+") ) and movie.yearMovie between '"+yearStart+"' and '"+yearEnd+"' order by genre.idMovie limit 0,10000000");
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


