import api from '../api';

export const FOLDER_FETCH_REQUEST = 'FOLDER_FETCH_REQUEST';
export const FOLDER_FETCH_SUCCESS = 'FOLDER_FETCH_SUCCESS';
export const FOLDER_FETCH_FAIL    = 'FOLDER_FETCH_FAIL';

export const FOLDERS_FETCH_REQUEST = 'FOLDERS_FETCH_REQUEST';
export const FOLDERS_FETCH_SUCCESS = 'FOLDERS_FETCH_SUCCESS';
export const FOLDERS_FETCH_FAIL    = 'FOLDERS_FETCH_FAIL';

export const FOLDER_EDITOR_NAME_CHANGE = 'FOLDER_EDITOR_NAME_CHANGE';
export const FOLDER_EDITOR_RESET       = 'FOLDER_EDITOR_RESET';
export const FOLDER_EDITOR_SETUP       = 'FOLDER_EDITOR_SETUP';

export const FOLDER_CREATE_REQUEST = 'FOLDER_CREATE_REQUEST';
export const FOLDER_CREATE_SUCCESS = 'FOLDER_CREATE_SUCCESS';
export const FOLDER_CREATE_FAIL    = 'FOLDER_CREATE_FAIL';

export const FOLDER_UPDATE_REQUEST = 'FOLDER_UPDATE_REQUEST';
export const FOLDER_UPDATE_SUCCESS = 'FOLDER_UPDATE_SUCCESS';
export const FOLDER_UPDATE_FAIL    = 'FOLDER_UPDATE_FAIL';

export const FOLDER_DELETE_REQUEST = 'FOLDER_DELETE_REQUEST';
export const FOLDER_DELETE_SUCCESS = 'FOLDER_DELETE_SUCCESS';
export const FOLDER_DELETE_FAIL    = 'FOLDER_DELETE_FAIL';

export const fetchFolder = id => (dispatch, getState) => {
  if (getState().getIn(['folders', id])) {
    return;
  }

  dispatch(fetchFolderRequest(id));

  api(getState).get(`/api/v1/folder_labels/${id}`)
    .then(({ data }) => dispatch(fetchFolderSuccess(data)))
    .catch(err => dispatch(fetchFolderFail(id, err)));
};

export const fetchFolderRequest = id => ({
  type: FOLDER_FETCH_REQUEST,
  id,
});

export const fetchFolderSuccess = folder => ({
  type: FOLDER_FETCH_SUCCESS,
  folder,
});

export const fetchFolderFail = (id, error) => ({
  type: FOLDER_FETCH_FAIL,
  id,
  error,
});

export const fetchFolders = () => (dispatch, getState) => {
  dispatch(fetchFoldersRequest());

  api(getState).get('/api/v1/folder_labels')
    .then(({ data }) => dispatch(fetchFoldersSuccess(data)))
    .catch(err => dispatch(fetchFoldersFail(err)));
};

export const fetchFoldersRequest = () => ({
  type: FOLDERS_FETCH_REQUEST,
});

export const fetchFoldersSuccess = folders => ({
  type: FOLDERS_FETCH_SUCCESS,
  folders,
});

export const fetchFoldersFail = error => ({
  type: FOLDERS_FETCH_FAIL,
  error,
});

export const submitFolderEditor = shouldReset => (dispatch, getState) => {
  const folderId = getState().getIn(['folderEditor', 'folderId']);
  const name  = getState().getIn(['folderEditor', 'name']);
  if (!name) {
    return;
  }

  if (folderId === null) {
    dispatch(createFolder(name, shouldReset));
  } else {
    dispatch(updateFolder(folderId, name, shouldReset));
  }
};

export const setupFolderEditor = folderId => (dispatch, getState) => {
  dispatch({
    type: FOLDER_EDITOR_SETUP,
    folder: getState().getIn(['folders', folderId]),
  });

};

export const changeFolderEditorName = value => ({
  type: FOLDER_EDITOR_NAME_CHANGE,
  value,
});

export const createFolder = (name, shouldReset) => (dispatch, getState) => {
  dispatch(createFolderRequest());

  api(getState).post('/api/v1/folder_labels', { name }).then(({ data }) => {
    dispatch(createFolderSuccess(data));

    if (shouldReset) {
      dispatch(resetFolderEditor());
    }
  }).catch(err => dispatch(createFolderFail(err)));
};

export const createFolderRequest = () => ({
  type: FOLDER_CREATE_REQUEST,
});

export const createFolderSuccess = folder => ({
  type: FOLDER_CREATE_SUCCESS,
  folder,
});

export const createFolderFail = error => ({
  type: FOLDER_CREATE_FAIL,
  error,
});

export const updateFolder = (id, name, shouldReset) => (dispatch, getState) => {
  dispatch(updateFolderRequest(id));

  api(getState).put(`/api/v1/folder_labels/${id}`, { name }).then(({ data }) => {
    dispatch(updateFolderSuccess(data));

    if (shouldReset) {
      dispatch(resetFolderEditor());
      dispatch(setupFolderEditor(id));
    }
  }).catch(err => dispatch(updateFolderFail(id, err)));
};

export const updateFolderRequest = id => ({
  type: FOLDER_UPDATE_REQUEST,
  id,
});

export const updateFolderSuccess = folder => ({
  type: FOLDER_UPDATE_SUCCESS,
  folder,
});

export const updateFolderFail = (id, error) => ({
  type: FOLDER_UPDATE_FAIL,
  id,
  error,
});

export const resetFolderEditor = () => ({
  type: FOLDER_EDITOR_RESET,
});

export const deleteFolder = id => (dispatch, getState) => {
  dispatch(deleteFolderRequest(id));

  api(getState).delete(`/api/v1/folder_labels/${id}`)
    .then(() => dispatch(deleteFolderSuccess(id)))
    .catch(err => dispatch(deleteFolderFail(id, err)));
};

export const deleteFolderRequest = id => ({
  type: FOLDER_DELETE_REQUEST,
  id,
});

export const deleteFolderSuccess = id => ({
  type: FOLDER_DELETE_SUCCESS,
  id,
});

export const deleteFolderFail = (id, error) => ({
  type: FOLDER_DELETE_FAIL,
  id,
  error,
});
