'use babel';

import FakeView from './fake-view';
import { CompositeDisposable } from 'atom';

export default {

  fakeView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.fakeView = new FakeView(state.fakeViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.fakeView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'fake:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.fakeView.destroy();
  },

  serialize() {
    return {
      fakeViewState: this.fakeView.serialize()
    };
  },

  toggle() {
    console.log('Fake was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
