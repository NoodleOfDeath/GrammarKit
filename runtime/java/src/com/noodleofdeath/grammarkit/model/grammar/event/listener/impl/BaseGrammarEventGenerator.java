package com.noodleofdeath.pastaparser.model.grammar.event.listener.impl;

import java.util.ArrayList;
import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.event.listener.GrammarEventGenerator;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.GrammarListener;

/**
 * @param <GL>
 */
public class BaseGrammarEventGenerator<GL extends GrammarListener> implements GrammarEventGenerator<GL> {

	/** */
	protected List<GL> listeners = new ArrayList<>();

	@Override
	public List<GL> listeners() {
		return listeners;
	}

	@Override
	public boolean addGrammarEventListener(GL listener) {
		return listeners.add(listener);
	}

	@Override
	public boolean removeGrammarEventListener(GL listener) {
		return listeners.remove(listener);
	}

	@Override
	public void removeAllGrammarEventListeners() {
		listeners.clear();
	}

}
