package com.noodleofdeath.pastaparser;

/** Specifications for a quantified object. */
public interface Quantified {

	/**
	 * Gets the quantifier of this object.
	 * 
	 * @return quantifier of this object.
	 */
	public abstract Quantifier quantifier();

	/**
	 * Sets the quanitifier of this object.
	 * 
	 * @param quantifier to set for this object.
	 */
	public abstract void setQuantifier(Quantifier quantifier);

}
