package com.noodleofdeath.pastaparser.model.graph;

import java.util.Collection;
import java.util.List;

/**
 * Specifications for a treethat extends {@link Node}.
 * 
 * @param <R> the type of parent and child nodes found within this entire tree.
 */
public interface Tree<R extends Tree<R>> extends Node<R> {

	/**
	 * <code>true</code> if this tree has no children; <code>false</code>, otherwise.
	 * 
	 * @return <code>true</code> if this tree has no children; <code>false</code>, otherwise.
	 */
	public default boolean isLeaf() {
		return children().size() == 0;
	}

	/**
	 * Child list of this tree.
	 * 
	 * @return child list of this tree.
	 */
	public abstract List<R> children();

	/**
	 * Appends the specified child to the end of the child list of this tree.
	 * 
	 * @param child to be appended to the child list of this tree.
	 * @return <code>true</code> (as specified by {@link Collection#add})
	 */
	public abstract boolean addChild(R child);

	/**
	 * Inserts the specified child at the specified position in the child list of
	 * this tree. Shifts the child currently at that position (if any) and any
	 * subsequent children to the right (adds one to their indices).
	 * 
	 * @param index at which the specified child is to be inserted.
	 * @param child to be inserted.
	 */
	public abstract void addChild(int index, R child);
	
	/** Sets the children of this tree.
	 * 
	 * @param children to set for this tree.
	 */
	public abstract void setChildren(List<R> children);

	/**
	 * Removes the first occurrence of the specified child from the child list of
	 * this tree, if it is present. If the list does not contain the child, it is
	 * unchanged. More formally, removes the child with the lowest index i such that
	 * (o==null ? get(i)==null : o.equals(get(i))) (if such an child exists).
	 * Returns true if the child list of this tree contained the specified child (or
	 * equivalently, if the child list of this tree changed as a result of the
	 * call).
	 * 
	 * @param child to be removed from the child list of this tree, if present
	 * @return <code>true</code> if the child list of this tree contained the specified
	 *         child.
	 */
	public abstract boolean removeChild(R child);

	/**
	 * Removes the child at the specified position in the child list of this tree.
	 * Shifts any subsequent children to the left (subtracts one from their
	 * indices).
	 * 
	 * @param index of the child to be removed
	 * @return the child that was removed from the child list of this tree.
	 */
	public abstract R removeChild(int index);

}
