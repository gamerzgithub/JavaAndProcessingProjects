import java.util.Comparator;
import java.util.List;

public class LeagueTableFormatter {
    private Comparator<LeagueStanding> leagueStandingComparator;
    private StringBuilder builder;
    private String tableEntryFormat;

    public LeagueTableFormatter() {
        leagueStandingComparator = new LeagueStandingComparator();
    }

    public String format(List<LeagueStanding> leagueTable) {
        initialiseData(leagueTable);

        int position = 1;
        int contiguouslyEqual = 0; //how many teams are in equal position
        boolean equal = false;
        for (int i = 0; i < leagueTable.size(); ++i) {
            if (equal) { //special case where the last two teams are in joint position, so maybe this one is too.
                if (inEqualPosition(leagueTable.get(i), leagueTable.get(i - 1))) { //this team is in equal position with the last 2 (or more) teams
                    appendTableEntry(getEqualPosition(position), leagueTable.get(i));
                    contiguouslyEqual++;
                } else { //this team is not in a joint position
                    equal = false;
                    position += contiguouslyEqual;
                    appendTableEntry(getPosition(position), leagueTable.get(i));
                    position++;
                    contiguouslyEqual = 0;
                }
            } else {
                if (i < (leagueTable.size() - 1) && inEqualPosition(leagueTable.get(i), leagueTable.get(i + 1))) { //the two teams are in equal position
                    equal = true;
                    appendTableEntry(getEqualPosition(position), leagueTable.get(i));
                    appendTableEntry(getEqualPosition(position), leagueTable.get(i + 1));
                    contiguouslyEqual += 2;
                    i++;//skip the element i+1 as we've already put it in the map
                } else {
                    appendTableEntry(getPosition(position), leagueTable.get(i));
                    position++;
                }
            }
        }
        return builder.toString();
    }

    private void initialiseData(List<LeagueStanding> leagueTable) {
        int longestTeamNameLength = getLongestTeamLength(leagueTable);

        String tableHeaderFormat = "%-11s %-"+longestTeamNameLength+"s %-7s %-6s %-6s %-6s %-10s %-14s %-16s %-6s %n";
        tableEntryFormat = "%-11s %-"+longestTeamNameLength+"s %d %7d %6d %6d %7d %9d %15d %16d%n";

        builder = new StringBuilder();
        builder.append(String.format(tableHeaderFormat, "Position", "Team", "Played", "Won", "Drawn", "Lost", "Goals For", "Goals Against", "Goal Difference", "Points"));
    }

    private int getLongestTeamLength(List<LeagueStanding> leagueTable) {
        int longestTeamName = 0;
        for (LeagueStanding ls : leagueTable) {
           if (ls.getTeam().length() > longestTeamName) longestTeamName = ls.getTeam().length();
        }
        longestTeamName++;

        return longestTeamName;
    }

    private boolean inEqualPosition(LeagueStanding l1, LeagueStanding l2) {
        return leagueStandingComparator.compare(l1, l2) == 0;
    }

    private void appendTableEntry(String position, LeagueStanding ls) {
        builder.append(String.format(tableEntryFormat, position, ls.getTeam(), ls.getPlayed(), ls.getWon(), ls.getDrawn(), ls.getLost(), ls.getGoalsFor(), ls.getGoalsAgainst(), ls.getGoalDifference(), ls.getPoints()));
    }

    private String getEqualPosition(int position) {
        return "=" + position;
    }

    private String getPosition(int position) {
        return "" + position;
    }
}
