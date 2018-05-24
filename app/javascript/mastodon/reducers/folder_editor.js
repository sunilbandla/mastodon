import { Map as ImmutableMap } from 'immutable';
import {
  FOLDER_EDITOR_RESET,
  FOLDER_EDITOR_SETUP,
  FOLDER_EDITOR_NAME_CHANGE,
} from '../actions/folders';

const initialState = ImmutableMap({
  folderId: null,
  isSubmitting: false,
  name: '',
});

export default function folderEditorReducer(state = initialState, action) {
  switch(action.type) {
  case FOLDER_EDITOR_RESET:
    return initialState;
  case FOLDER_EDITOR_SETUP:
    return state.withMutations(map => {
      map.set('name', action.folder && action.folder.get('name'));
      map.set('folderId', action.folder && action.folder.get('id'));
      map.set('isSubmitting', false);
    });
  case FOLDER_EDITOR_NAME_CHANGE:
    return state.set('name', action.value);
  default:
    return state;
  }
};
