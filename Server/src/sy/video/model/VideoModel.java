package sy.video.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.jws.WebService;

import sy.config.MainConfig;
import sy.video.valueobj.Movie;

/**
 * 
 * @author Sy Le lenguyensy@gmail.com
 */
@WebService
public class VideoModel {
	Connection con = MainConfig.getConnection();

	private List<Movie> _getMovieList(ResultSet rs) {
		List<Movie> lstMovie = new ArrayList<Movie>();

		try {
			while (rs.next()) {
				Movie m = new Movie();
				m.setMovieName(rs.getString("moviename"));
				m.setMovieBanner(rs.getString("moviebanner"));
				m.setReleaseDate(rs.getInt("releasedate"));
				m.setRentAmount(rs.getFloat("rentamount"));
				m.setAvailableCopies(rs.getInt("availablecopies"));

				lstMovie.add(m);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return lstMovie;
	}

	/**
	 * get a list of available movies
	 * 
	 * @return
	 */
	public Movie[] getMovies() {
		List<Movie> lstMov = new ArrayList<Movie>();

		try {
			PreparedStatement stmt = con
					.prepareStatement("SELECT * FROM movies");

			ResultSet rs = stmt.executeQuery();
			lstMov = _getMovieList(rs);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return lstMov.toArray(new Movie[lstMov.size()]);
	}

	/**
	 * get a single movie by movie id
	 * 
	 * @param movieId
	 * @return
	 */
	public Movie getMovie(int movieId) {
		List<Movie> lstMov = new ArrayList<Movie>();

		try {
			PreparedStatement stmt = con
					.prepareStatement("SELECT * FROM movies WHERE id = ?");
			stmt.setInt(1, movieId);

			ResultSet rs = stmt.executeQuery();
			lstMov = _getMovieList(rs);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (lstMov.size() == 1)
			return lstMov.get(0);
		else
			return null;
	}

	/**
	 * add movie
	 * 
	 * @param m
	 * @return
	 */
	public int addMovie(Movie m) {
		try {
			PreparedStatement stmt = con
					.prepareStatement("INSERT INTO movies (moviename,moviebanner,releasedate,rentamount,availablecopies) "
							+ "VALUES (?,?,?,?,?)");
			stmt.setString(1, m.getMovieName());
			stmt.setString(2, m.getMovieBanner());
			stmt.setInt(3, m.getReleaseDate());
			stmt.setFloat(4, m.getRentAmount());
			stmt.setInt(5, m.getAvailableCopies());

			stmt.execute();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return 0;
	}

	/**
	 * delete a movie
	 * 
	 * @param movieId
	 * @return
	 */
	public int deletMovie(int movieId) {
		try {
			PreparedStatement stmt = con
					.prepareStatement("DELETE * FROM movies WHERE id = ?");
			stmt.setInt(1, movieId);

			stmt.execute();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return 0;
	}

	/**
	 * save movie
	 * 
	 * @param m
	 */
	public void saveMovie(Movie m) {
		try {
			PreparedStatement stmt = con
					.prepareStatement("UPDATE movies SET moviename = ?,"
							+ " moviebanner = ?, " + "releasedate = ?, "
							+ " rentamount = ?, " + "availablecopies =? "
							+ " WHERE id = ?");
			stmt.setString(1, m.getMovieName());
			stmt.setString(2, m.getMovieBanner());
			stmt.setInt(3, m.getReleaseDate());
			stmt.setFloat(4, m.getRentAmount());
			stmt.setInt(5, m.getAvailableCopies());
			stmt.setString(6, m.getMovieId());

			stmt.execute();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}