import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import StatusListContainer from '../ui/containers/status_list_container';
import Column from '../../components/column';
import ColumnBackButton from '../../components/column_back_button';
import ColumnHeader from '../../components/column_header';
import { addColumn, removeColumn, moveColumn } from '../../actions/columns';
import { FormattedMessage, defineMessages, injectIntl } from 'react-intl';
import { connectFolderStream } from '../../actions/streaming';
import { expandFolderTimeline } from '../../actions/timelines';
import { fetchFolder, deleteFolder } from '../../actions/folders';
import { openModal } from '../../actions/modal';
import MissingIndicator from '../../components/missing_indicator';
import LoadingIndicator from '../../components/loading_indicator';

const messages = defineMessages({
  deleteMessage: { id: 'confirmations.delete_folder.message', defaultMessage: 'Are you sure you want to permanently delete this folder?' },
  deleteConfirm: { id: 'confirmations.delete_folder.confirm', defaultMessage: 'Delete' },
});

const mapStateToProps = (state, props) => ({
  folder: state.getIn(['folders', +props.params.id]),
  hasUnread: state.getIn(['timelines', `folder:${props.params.id}`, 'unread']) > 0,
});

@connect(mapStateToProps)
@injectIntl
export default class FolderTimeline extends React.PureComponent {

  static contextTypes = {
    router: PropTypes.object,
  };

  static propTypes = {
    params: PropTypes.object.isRequired,
    dispatch: PropTypes.func.isRequired,
    shouldUpdateScroll: PropTypes.func,
    columnId: PropTypes.string,
    hasUnread: PropTypes.bool,
    multiColumn: PropTypes.bool,
    folder: PropTypes.oneOfType([ImmutablePropTypes.map, PropTypes.bool]),
    intl: PropTypes.object.isRequired,
  };

  handlePin = () => {
    const { columnId, dispatch } = this.props;

    if (columnId) {
      dispatch(removeColumn(columnId));
    } else {
      dispatch(addColumn('FOLDER', { id: this.props.params.id }));
      this.context.router.history.push('/');
    }
  }

  handleMove = (dir) => {
    const { columnId, dispatch } = this.props;
    dispatch(moveColumn(columnId, dir));
  }

  handleHeaderClick = () => {
    this.column.scrollTop();
  }

  componentDidMount () {
    const { dispatch } = this.props;
    const { id } = this.props.params;

    dispatch(fetchFolder(id));
    dispatch(expandFolderTimeline(id));

    this.disconnect = dispatch(connectFolderStream(id));
  }

  componentWillUnmount () {
    if (this.disconnect) {
      this.disconnect();
      this.disconnect = null;
    }
  }

  setRef = c => {
    this.column = c;
  }

  handleLoadMore = maxId => {
    const { id } = this.props.params;
    this.props.dispatch(expandFolderTimeline(id, { maxId }));
  }

  handleEditClick = () => {
    this.props.dispatch(openModal('FOLDER_EDITOR', { folderId: +this.props.params.id }));
  }

  handleDeleteClick = () => {
    const { dispatch, columnId, intl } = this.props;
    const { id } = this.props.params;

    dispatch(openModal('CONFIRM', {
      message: intl.formatMessage(messages.deleteMessage),
      confirm: intl.formatMessage(messages.deleteConfirm),
      onConfirm: () => {
        dispatch(deleteFolder(+id));

        if (!!columnId) {
          dispatch(removeColumn(columnId));
        } else {
          this.context.router.history.push('/folders');
        }
      },
    }));
  }

  render () {
    const { shouldUpdateScroll, hasUnread, columnId, multiColumn, folder } = this.props;
    const { id } = this.props.params;
    const pinned = !!columnId;
    const title  = folder ? folder.get('name') : id;

    if (typeof folder === 'undefined') {
      return (
        <Column>
          <div className='scrollable'>
            <LoadingIndicator />
          </div>
        </Column>
      );
    } else if (folder === false) {
      return (
        <Column>
          <ColumnBackButton />
          <MissingIndicator />
        </Column>
      );
    }

    return (
      <Column ref={this.setRef}>
        <ColumnHeader
          icon='list-ul'
          active={hasUnread}
          title={title}
          onPin={this.handlePin}
          onMove={this.handleMove}
          onClick={this.handleHeaderClick}
          pinned={pinned}
          multiColumn={multiColumn}
        >
          <div className='column-header__links'>
            <button className='text-btn column-header__setting-btn' tabIndex='0' onClick={this.handleEditClick}>
              <i className='fa fa-pencil' /> <FormattedMessage id='folders.edit' defaultMessage='Edit folder' />
            </button>

            <button className='text-btn column-header__setting-btn' tabIndex='0' onClick={this.handleDeleteClick}>
              <i className='fa fa-trash' /> <FormattedMessage id='folders.delete' defaultMessage='Delete folder' />
            </button>
          </div>

          <hr />
        </ColumnHeader>

        <StatusListContainer
          trackScroll={!pinned}
          scrollKey={`folder_timeline-${columnId}`}
          timelineId={`folder:${id}`}
          onLoadMore={this.handleLoadMore}
          emptyMessage={<FormattedMessage id='empty_column.folder' defaultMessage='There is nothing in this folder yet.' />}
          shouldUpdateScroll={shouldUpdateScroll}
        />
      </Column>
    );
  }

}
