/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 17*****46
 */


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.Graphics.*;

public class AnimatedGUI implements ActionListener
{
	private JFrame frame;

	private int x;
	private int xvel;
	
	private int y;
	private int yvel;
	
	private int diameter;
	
	private boolean animateShapes;
	private boolean animateOval;
	private boolean animateRect;
	
	private JButton startStopRectAnimationButton;
	private JButton startStopOvalAnimationButton;
	
	private ShapesDrawPanel drawPanel;
	private OvalActionListener drawOval;
	private RectActionListener drawRect;
	
	
	public AnimatedGUI(){
		x = 1;
		xvel = 1;
		y = 1;
		yvel = 1;
		
		diameter=50;
		animateShapes = true;
		animateOval = true;
		animateRect = true;
		
		drawPanel = new ShapesDrawPanel();
		
	}		

	public static void main (String[] args){
		AnimatedGUI gui = new AnimatedGUI();
		gui.go();
	}

	public void go(){
		frame = new JFrame();
		
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		drawOval = new OvalActionListener();
		drawRect = new RectActionListener();
		
		startStopRectAnimationButton = new JButton("click me to stop/run square the animation");
		startStopOvalAnimationButton = new JButton("click me to stop/run circle animation");
		
		frame.getContentPane().add(startStopRectAnimationButton, BorderLayout.PAGE_START);
		frame.getContentPane().add(startStopOvalAnimationButton, BorderLayout.PAGE_END);

		frame.getContentPane().add(drawPanel, BorderLayout.CENTER);
	
		startStopOvalAnimationButton.addActionListener(drawOval);
		startStopRectAnimationButton.addActionListener(drawRect);

		frame.setSize(500,500);
		frame.setVisible(true);
	}

	public void actionPerformed (ActionEvent e){
		animateShapes=false;
		drawPanel.repaint();
	}



	class ShapesDrawPanel extends JPanel{
		public void paintComponent (Graphics g){
			Graphics2D g2=(Graphics2D)g;
			g2.setColor(Color.yellow);
			g2.fillRect(0,0,this.getWidth(), this.getHeight());
			g2.setColor(Color.blue);
			g2.fillOval((this.getWidth()-(diameter+x))/2,(this.getHeight()-(diameter+x))/2,diameter+x,diameter+x);
			g2.setColor(Color.red);
			g2.fillRect(y,0,50,50);
			if (animateOval) drawOval.animateOval();
			if(animateRect) drawRect.animateRect();
		}
		
		public void animateShapes(){
			try{
				Thread.sleep(5);
			}
			catch (Exception ex){}
			repaint();
		}	
	}
	
	class OvalActionListener extends JPanel implements ActionListener{
	
		public void animateOval(){
			try{
				Thread.sleep(5);
				if(!animateRect)
					Thread.sleep(5);
			}
			catch (Exception ex){}
			if (x >= frame.getWidth()-diameter || x >= frame.getHeight()-diameter || x < 0) {
				xvel = -xvel;
			}
			x+=xvel; 
			drawPanel.repaint();
		}
		
		public void actionPerformed(ActionEvent e) {
			if(animateOval)
				animateOval = false;
			else
				animateOval = true;
			drawPanel.repaint();
		}	
	}
	
	class RectActionListener extends JPanel implements ActionListener{

		public void animateRect(){
			try{
				Thread.sleep(5);
				if (!animateOval) 
					Thread.sleep(5);
			}
			catch (Exception ex){}
			
			if (y > frame.getWidth()-50 || y < 0) {
				yvel = -yvel;
			}
			y += yvel;
			drawPanel.repaint();
		}

		public void actionPerformed(ActionEvent e) {
			if (animateRect)
				animateRect = false;
			else 
				animateRect = true;
			drawPanel.repaint();
		}
		
		
	}
}
