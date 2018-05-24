import {
  FOLDER_FETCH_SUCCESS,
  FOLDER_FETCH_FAIL,
  FOLDERS_FETCH_SUCCESS,
  FOLDER_CREATE_SUCCESS,
  FOLDER_UPDATE_SUCCESS,
  FOLDER_DELETE_SUCCESS,
} from '../actions/folders';
import { Map as ImmutableMap, fromJS } from 'immutable';

const initialState = ImmutableMap();

const normalizeFolder = (state, folder) => state.set(folder.id, fromJS(folder));

const normalizeFolders = (state, folders) => {
  folders.forEach(folder => {
    state = normalizeFolder(state, folder);
  });
  return state;
};

export default function folders(state = initialState, action) {
  switch(action.type) {
  case FOLDER_FETCH_SUCCESS:
  case FOLDER_CREATE_SUCCESS:
  case FOLDER_UPDATE_SUCCESS:
    return normalizeFolder(state, action.folder);
  case FOLDERS_FETCH_SUCCESS:
    return normalizeFolders(state, action.folders);
  case FOLDER_DELETE_SUCCESS:
  case FOLDER_FETCH_FAIL:
    return state.set(action.id, false);
  default:
    return state;
  }
};
