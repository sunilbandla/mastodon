import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import ImmutablePureComponent from 'react-immutable-pure-component';
import { injectIntl } from 'react-intl';
import { setupFolderEditor, resetFolderEditor } from '../../actions/folders';
import NewFolderForm from '../folders/components/new_folder_form';

const mapStateToProps = state => ({
  name: state.getIn(['folderEditor', 'name']),
});

const mapDispatchToProps = dispatch => ({
  onInitialize: folderId => dispatch(setupFolderEditor(folderId)),
  onReset: () => dispatch(resetFolderEditor()),
});

@connect(mapStateToProps, mapDispatchToProps)
@injectIntl
export default class FolderEditor extends ImmutablePureComponent {

  static propTypes = {
    folderId: PropTypes.number.isRequired,
    onClose: PropTypes.func.isRequired,
    intl: PropTypes.object.isRequired,
    onInitialize: PropTypes.func.isRequired,
    onReset: PropTypes.func.isRequired,
    name: PropTypes.string.isRequired,
  };

  componentDidMount () {
    const { onInitialize, folderId } = this.props;
    onInitialize(folderId);
  }

  componentWillUnmount () {
    const { onReset } = this.props;
    onReset();
  }

  render () {
    const { name } = this.props;

    return (
      <div className='modal-root__modal list-editor'>
        <NewFolderForm value={name} />
      </div>
    );
  }

}
