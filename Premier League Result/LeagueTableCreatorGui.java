/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 17*****46
 */

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.List;

public class LeagueTableCreatorGui {
    private static final String parseButtonText = "Parse Match Results";
    private static final String addButtonText = "Parse Match Results And Add To League Table";
    private static final String addDeserialisedButtonText = "Deserialise Match Results And Add To League Table";
    private static final String serialiseButtonText = "Serialise Match Results";
    private static final String deserialiseButtonText = "Deserialise Match Results";
    private static final String saveButtonText = "Save League Table As Text File";
    private static final String quitButtonText = "Quit Program";

    private JTextArea text;
    private JButton parseButton;
    private JButton addButton;
    private JButton addDeserialisedButton;
    private JButton serialiseButton;
    private JButton deserialiseButton;
    private JButton saveButton;
    private JButton quitButton;
    private JList<LocalDate> dateList;
    private DefaultListModel<LocalDate> dateListModel;
    private JFrame frame;
    private JFileChooser fileChooser;

    private List<DatedMatchResult> matchResults;
    private DatedMatchResultParser parser;
    private LeagueTableFormatter formatter;

    public LeagueTableCreatorGui() {
        matchResults = new ArrayList<>();
        parser = new DatedMatchResultParser();
        formatter = new LeagueTableFormatter();
        constructGui();
    }

    private void constructGui() {
        frame = new JFrame();
        fileChooser = new JFileChooser();

        JPanel westPanel = new JPanel();
        JPanel buttonPanel = createButtonPanel();
        JScrollPane datesScrollPane = createDatesScrollPane();
        westPanel.add(buttonPanel);
        westPanel.add(datesScrollPane);

        JPanel leagueTablePanel = createLeagueTablePanel();

        frame.getContentPane().add(westPanel, BorderLayout.WEST);
        frame.getContentPane().add(leagueTablePanel, BorderLayout.CENTER);

        frame.setSize(1285,450);
        frame.setVisible(true);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    private JPanel createLeagueTablePanel() {
        text = new JTextArea(26,107);
        text.setLineWrap(false); //need to set to false to make the horizontal scroller work
        text.setEditable(false);
        text.setFont(new Font("monospaced", Font.PLAIN, 12));
        JScrollPane textScroller = new JScrollPane(text);
        textScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
        textScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);

        JPanel panel = new JPanel();
        panel.add(textScroller);

        return panel;
    }

    private JPanel createButtonPanel() {
        JPanel buttonPanel = new JPanel();
        parseButton = new JButton(parseButtonText);
        parseButton.addActionListener(new ParseButtonAction());

        addButton = new JButton(addButtonText);
        addButton.addActionListener(new ParseAndAppendButtonAction());

        addDeserialisedButton = new JButton(addDeserialisedButtonText);
        addDeserialisedButton.addActionListener(new DeserialiseAndAppendButtonAction());

        serialiseButton = new JButton(serialiseButtonText);
        serialiseButton.addActionListener(new SerialiseButtonAction());

        saveButton = new JButton(saveButtonText);
        saveButton.addActionListener(new SaveButtonAction());

        deserialiseButton = new JButton(deserialiseButtonText);
        deserialiseButton.addActionListener(new DeserialiseButtonAction());

        quitButton = new JButton(quitButtonText);
        quitButton.addActionListener(new QuitButtonAction());

        buttonPanel.setLayout(new BoxLayout(buttonPanel, BoxLayout.PAGE_AXIS));

        GridLayout gridLayout = new GridLayout(0,1);
        JPanel saveButtonsPanel = new JPanel();
        JPanel addButtonsPanel = new JPanel();
        JPanel createButtonsPanel = new JPanel();
        JPanel quitButtonPanel = new JPanel();

        saveButtonsPanel.setLayout(gridLayout);
        addButtonsPanel.setLayout(gridLayout);
        createButtonsPanel.setLayout(gridLayout);
        quitButtonPanel.setLayout(gridLayout);


        TitledBorder saveTitledBorder = BorderFactory.createTitledBorder("Save To Disk");
        TitledBorder addTitledBorder = BorderFactory.createTitledBorder("Add Results To League Table");
        TitledBorder createTitledBorder = BorderFactory.createTitledBorder("Create New League Table");
        TitledBorder quitTitledBorder = BorderFactory.createTitledBorder("Quit");

        saveButtonsPanel.setBorder(saveTitledBorder);
        addButtonsPanel.setBorder(addTitledBorder);
        createButtonsPanel.setBorder(createTitledBorder);
        quitButtonPanel.setBorder(quitTitledBorder);

        createButtonsPanel.add(parseButton);
        createButtonsPanel.add(deserialiseButton);

        addButtonsPanel.add(addButton);
        addButtonsPanel.add(addDeserialisedButton);

        saveButtonsPanel.add(serialiseButton);
        saveButtonsPanel.add(saveButton);

        quitButtonPanel.add(quitButton);

        buttonPanel.add(createButtonsPanel);
        buttonPanel.add(Box.createRigidArea(new Dimension(0,20)));
        buttonPanel.add(addButtonsPanel);
        buttonPanel.add(Box.createRigidArea(new Dimension(0,20)));
        buttonPanel.add(saveButtonsPanel);
        buttonPanel.add(Box.createRigidArea(new Dimension(0,20)));
        buttonPanel.add(quitButtonPanel);

        return buttonPanel;
    }

    private JScrollPane createDatesScrollPane() {
        dateList = new JList<>();
        dateList.addListSelectionListener(new DateListSelectionListener());
        JScrollPane dateScroller = new JScrollPane(dateList);
        dateScroller.setPreferredSize(new Dimension(105,409));

        dateScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
        dateScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        return dateScroller;
    }

    private void loadMatchResults(File file) {
        try {
            matchResults = parser.parse(file);
        } catch (IOException e) {
            showErrorMessage("Parsing Error", "Could not parse selected file: " + e.getLocalizedMessage());
        }
    }

    private void constructLeagueTable() {
        constructLeagueTable(LocalDate.now());
    }

    private void constructLeagueTable(LocalDate date) {
        LeagueTableCreator tableCreator = new LeagueTableCreator(matchResults);
        List<LeagueStanding> leagueStandings = tableCreator.calculateLeagueTable(date);
        String formattedLeagueTable = formatter.format(leagueStandings);
        text.setText(formattedLeagueTable);
    }

    private void buildDateList() {
        List<LocalDate> dates = new ArrayList<>();
        for (DatedMatchResult result : matchResults) {
            if (!dates.contains(result.getDate()))
            dates.add(result.getDate());
        }
        Collections.sort(dates);
        dateListModel = new DefaultListModel<>();
        for (LocalDate date : dates) {
            dateListModel.addElement(date);
        }
        dateList.setModel(dateListModel);
        int lastIndex = dateListModel.getSize() - 1;
        dateList.setSelectedIndex(lastIndex);
        dateList.ensureIndexIsVisible(lastIndex);
    }

    private void deserialiseMatchResults(File file) {
        try {
            matchResults = SerializationUtil.deserialize(file);
        } catch (IOException | ClassNotFoundException e) {
            showErrorMessage("Deserialisation Error", "Error while deserialising: " + e.getLocalizedMessage());
        }
    }
	
	private void serialiseMatchResults(File file, List<DatedMatchResult> result) {
    	try {
    		SerializationUtil.serialize(file, result);
    	}catch (IOException | ClassNotFoundException e) {
    		showErrorMessage("Serialisation Error", "Error while serialising: "+e.getLocalizedMessage());
    	}
    }

    private void saveLeagueTable(File file) {
        try {
            LeagueTableFileWriter.write(text.getText(), file);
        } catch (IOException e) {
            showErrorMessage("Error Saving File","Error writing to file: " + e.getLocalizedMessage());
        }
    }

    private void showErrorMessage(String title, String message) {
        JOptionPane.showMessageDialog(frame, message, title, JOptionPane.ERROR_MESSAGE);
    }

    private void appendMatchResults(File file) {
        try {
            List<DatedMatchResult> newResults = parser.parse(file);
            addNewResults(newResults);
        } catch (IOException e) {
            showErrorMessage("Parsing Error", "Could not parse selected file: " + e.getLocalizedMessage());
        }
    }

    private void appendDeserialisedMatchResults(File file) {
        try {
            List<DatedMatchResult> newResults = SerializationUtil.deserialize(file);
            addNewResults(newResults);
        } catch (IOException | ClassNotFoundException e) {
            showErrorMessage("Deserialisation Error", "Error while deserialising: " + e.getLocalizedMessage());
        }
    }

    private void addNewResults(List<DatedMatchResult> newResults) {
        if (!matchResults.containsAll(newResults)) { //only add results we don't already have
            //filter results in case there's some duplicates
            for (DatedMatchResult result : newResults) {
                if (!matchResults.contains(result)) {
                    matchResults.add(result);
                }
            }
        }
    }

    public static void main(String[] args) {
       new LeagueTableCreatorGui();
    }

    private class ParseButtonAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int returnVal = fileChooser.showOpenDialog(frame);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = fileChooser.getSelectedFile();
                loadMatchResults(file);
                buildDateList();
                constructLeagueTable();
            }
        }
    }

    private class DeserialiseButtonAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int returnVal = fileChooser.showOpenDialog(frame);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                deserialiseMatchResults(fileChooser.getSelectedFile());
                buildDateList();
                constructLeagueTable();
            }
        }
    }

    private class SerialiseButtonAction implements ActionListener{
		private static final long serialVersionUID = 1L;

		@Override
		public void actionPerformed(ActionEvent e) {
			String checkEmptyTextWithoutSpace = text.getText().trim();
			
			if (!checkEmptyTextWithoutSpace.equals("")) {
				int returnVal = fileChooser.showSaveDialog(frame);
				if (returnVal == JFileChooser.APPROVE_OPTION) {
					serialiseMatchResults(fileChooser.getSelectedFile(), matchResults);
				}
			}
			else {
				System.err.println("Error! Please parse the results before serialising.");
			}
		}
    }

    private class SaveButtonAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int returnVal = fileChooser.showSaveDialog(frame);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                saveLeagueTable(fileChooser.getSelectedFile());
            }
        }
    }

    private class DateListSelectionListener implements ListSelectionListener {
        @Override
        public void valueChanged(ListSelectionEvent e) {
            if (!e.getValueIsAdjusting()) {
                if (dateList.getSelectedIndex() != -1) {
                    LocalDate date = dateListModel.elementAt(dateList.getSelectedIndex());
                    constructLeagueTable(date);
                }
            }
        }
    }

    private class ParseAndAppendButtonAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int returnVal = fileChooser.showOpenDialog(frame);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = fileChooser.getSelectedFile();
                appendMatchResults(file);
                buildDateList();
                constructLeagueTable();
            }
        }
    }

    private class QuitButtonAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }

    private class DeserialiseAndAppendButtonAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int returnVal = fileChooser.showOpenDialog(frame);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = fileChooser.getSelectedFile();
                appendDeserialisedMatchResults(file);
                buildDateList();
                constructLeagueTable();
            }
        }
    }
	
	/* Question 6:
     * The createDatesScrollPane() method in the LeagueTableCreatorGui class makes a JScrollPane displaying 
     * a JList – in this instance a clickable list of objects of type LocalDate. An inner class implementation 
     * of the ListSelectionListener interface listens to the JList and when a date is clicked by the user it
     * calls the method constructLeagueTable(LocalDate date), where the date clicked is parsed into this 
     * method as a parameter. 
     * Next, the constructLeagueTable method will create a new object of the LeagueTableCreator class to store
     * match results as a table, and the method calculateLeagueTable(LocalDate date) will be called to calculate
     * the results up to the date clicked by user. How this was done is that the results that comes before the date
     * clicked by the user will be total up for each team, using the addIfInDataRange(DatedMatchResult result) method. 
     * The calculated result will be store in a new list of LeagueStanding type object to be formatted and displayed. 
     * After formatting the LeagueStanding object as a String type variable, the variable will be displayed in the 
     * JTextArea with the method setText(String s).
     */
}
