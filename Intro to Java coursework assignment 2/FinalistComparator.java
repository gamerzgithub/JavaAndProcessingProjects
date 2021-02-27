import java.util.Comparator;

 //sort by degree mark, descending

class FinalistComparator implements Comparator<Finalist> {
	@Override
	public int compare(Finalist f1, Finalist f2) {
		int degreeComparisonResult = Double.compare(f2.getDegreeMark(),f1.getDegreeMark());
			return degreeComparisonResult;
	}
}
//compare() method from the Double class returns: the value 0 if d1 is numerically equal to d2; a value less than 0 if d1 is numerically less than d2; and a value greater than 0 if d1 is numerically greater than d2.