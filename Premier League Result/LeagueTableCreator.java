import java.time.LocalDate;
import java.util.*;

public class LeagueTableCreator {
    private List<DatedMatchResult> results;
    private Map<String, LeagueStanding> tabulatedResults;
    private LocalDate onOrBeforeThisDate;

    public LeagueTableCreator(List<DatedMatchResult> results) {
        this.results = results;
    }

    public List<LeagueStanding> calculateLeagueTable(LocalDate onThisDate) {
        initialiseData(onThisDate);

        for (DatedMatchResult result : results) {
            addIfInDateRange(result);
        }

        return getLeagueTable();
    }

    public List<LeagueStanding> calculateLeagueTable() {
        return calculateLeagueTable(LocalDate.now());
    }

    private List<LeagueStanding> getLeagueTable() {
        ArrayList<LeagueStanding> standings = new ArrayList<>(tabulatedResults.values());
        standings.sort(new LeagueStandingComparator());

        return standings;
    }

    private void addIfInDateRange(DatedMatchResult result) {
        if (result.getDate().isAfter(onOrBeforeThisDate)) {
            return;
        }

        updateLeagueStandings(result);
    }

    private void updateLeagueStandings(DatedMatchResult result) {
        updatePlayedStats(result);

        updateGoalStats(result);

        if (isHomeWin(result)) {
            recordHomeWin(result);
        } else if (isAwayWin(result)) {
            recordAwayWin(result);
        } else { //it's a draw
            recordDraw(result);
        }
    }

    private void updatePlayedStats(DatedMatchResult result) {
        LeagueStanding homeTeamStanding = getHomeTeam(result);
        LeagueStanding awayTeamStanding = getAwayTeam(result);

        int newHomePlayed = homeTeamStanding.getPlayed() + 1;
        homeTeamStanding.setPlayed(newHomePlayed);

        int newAwayPlayed = awayTeamStanding.getPlayed() + 1;
        awayTeamStanding.setPlayed(newAwayPlayed);
    }

    private void updateGoalStats(DatedMatchResult result) {
        LeagueStanding homeTeamStanding = getHomeTeam(result);
        LeagueStanding awayTeamStanding = getAwayTeam(result);

        int homeScore = result.getHomeScore();
        int awayScore = result.getAwayScore();

        int newHomeGoalsFor = homeTeamStanding.getGoalsFor() + homeScore;
        homeTeamStanding.setGoalsFor(newHomeGoalsFor);

        int newAwayGoalsFor = awayTeamStanding.getGoalsFor() + awayScore;
        awayTeamStanding.setGoalsFor(newAwayGoalsFor);

        int newHomeGoalsAgainst = homeTeamStanding.getGoalsAgainst() + awayScore;
        homeTeamStanding.setGoalsAgainst(newHomeGoalsAgainst);

        int newAwayGoalsAgainst = awayTeamStanding.getGoalsAgainst() + homeScore;
        awayTeamStanding.setGoalsAgainst(newAwayGoalsAgainst);

        int newHomeGoalDifference = homeTeamStanding.getGoalsFor() - homeTeamStanding.getGoalsAgainst();
        homeTeamStanding.setGoalDifference(newHomeGoalDifference);

        int newAwayGoalDifference = awayTeamStanding.getGoalsFor() - awayTeamStanding.getGoalsAgainst();
        awayTeamStanding.setGoalDifference(newAwayGoalDifference);
    }

    private void recordHomeWin(DatedMatchResult result) {
        LeagueStanding homeTeamStanding = getHomeTeam(result);
        LeagueStanding awayTeamStanding = getAwayTeam(result);

        int newHomeWon = homeTeamStanding.getWon() + 1;
        homeTeamStanding.setWon(newHomeWon);

        int newAwayLost = awayTeamStanding.getLost() + 1;
        awayTeamStanding.setLost(newAwayLost);

        int newHomePoints = homeTeamStanding.getPoints() + 3;
        homeTeamStanding.setPoints(newHomePoints);
    }

    private void recordAwayWin(DatedMatchResult result) {
        LeagueStanding homeTeamStanding = getHomeTeam(result);
        LeagueStanding awayTeamStanding = getAwayTeam(result);

        int newAwayWon = awayTeamStanding.getWon() + 1;
        awayTeamStanding.setWon(newAwayWon);

        int newHomeLost = homeTeamStanding.getLost() + 1;
        homeTeamStanding.setLost(newHomeLost);

        int newAwayPoints = awayTeamStanding.getPoints() + 3;
        awayTeamStanding.setPoints(newAwayPoints);
    }

    private void recordDraw(DatedMatchResult result) {
        LeagueStanding homeTeamStanding = getHomeTeam(result);
        LeagueStanding awayTeamStanding = getAwayTeam(result);

        int newHomeDrawn = homeTeamStanding.getDrawn() + 1;
        homeTeamStanding.setDrawn(newHomeDrawn);

        int newAwayDrawn = awayTeamStanding.getDrawn() + 1;
        awayTeamStanding.setDrawn(newAwayDrawn);

        int newHomePoints = homeTeamStanding.getPoints() + 1;
        homeTeamStanding.setPoints(newHomePoints);

        int newAwayPoints = awayTeamStanding.getPoints() + 1;
        awayTeamStanding.setPoints(newAwayPoints);
    }

    private boolean isHomeWin(DatedMatchResult result) {
        return result.getHomeScore() > result.getAwayScore();
    }

    private boolean isAwayWin(DatedMatchResult result) {
        return result.getAwayScore() > result.getHomeScore();
    }

    private LeagueStanding getHomeTeam(DatedMatchResult result) {
        return tabulatedResults.get(result.getHomeTeam());
    }

    private LeagueStanding getAwayTeam(DatedMatchResult result) {
        return tabulatedResults.get(result.getAwayTeam());
    }

    private void initialiseData(LocalDate date) {
        tabulatedResults = new TreeMap<>();
        onOrBeforeThisDate = date;

        for (DatedMatchResult result : results) {
            String team = result.getHomeTeam();
            if (!tabulatedResults.keySet().contains(team)) {
                tabulatedResults.put(team, new LeagueStanding(team));
            }
        }
    }
}
