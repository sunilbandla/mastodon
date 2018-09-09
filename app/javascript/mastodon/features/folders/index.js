import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import LoadingIndicator from '../../components/loading_indicator';
import Column from '../ui/components/column';
import ColumnBackButtonSlim from '../../components/column_back_button_slim';
import { fetchFolders } from '../../actions/folders';
import { defineMessages, injectIntl, FormattedMessage } from 'react-intl';
import ImmutablePureComponent from 'react-immutable-pure-component';
import ColumnLink from '../ui/components/column_link';
import ColumnSubheading from '../ui/components/column_subheading';
import NewFolderForm from './components/new_folder_form';
import { createSelector } from 'reselect';
import ScrollableList from '../../components/scrollable_list';

const messages = defineMessages({
  heading: { id: 'column.folders', defaultMessage: 'Folders' },
  subheading: { id: 'folders.subheading', defaultMessage: 'Your folders' },
});

const getOrderedFolders = createSelector([state => state.get('folders')], folders => {
  if (!folders) {
    return folders;
  }
  return folders.toList().filter(item => !!item).sort((a, b) => a.get('name').localeCompare(b.get('name')));
});

const mapStateToProps = state => ({
  folders: getOrderedFolders(state),
});

@connect(mapStateToProps)
@injectIntl
export default class Folders extends ImmutablePureComponent {

  static propTypes = {
    params: PropTypes.object.isRequired,
    dispatch: PropTypes.func.isRequired,
    folders: ImmutablePropTypes.list,
    intl: PropTypes.object.isRequired,
  };

  componentWillMount () {
    this.props.dispatch(fetchFolders());
  }

  render () {
    const { intl, shouldUpdateScroll, folders } = this.props;

    if (!folders) {
      return (
        <Column>
          <LoadingIndicator />
        </Column>
      );
    }

    const emptyMessage = <FormattedMessage id='empty_column.folders' defaultMessage="You don't have any lists yet. When you create one, it will show up here." />;

    return (
      <Column icon='list-ul' heading={intl.formatMessage(messages.heading)}>
        <ColumnBackButtonSlim />

        <NewFolderForm />

        <ColumnSubheading text={intl.formatMessage(messages.subheading)} />
        <ScrollableList
          scrollKey='folders'
          shouldUpdateScroll={shouldUpdateScroll}
          emptyMessage={emptyMessage}
        >
          {folders.map(folder =>
            <ColumnLink key={folder.get('id')} to={`/timelines/folder/${folder.get('id')}`} icon='list-ul' text={folder.get('name')} />
          )}
        </ScrollableList>
      </Column>
    );
  }

}
