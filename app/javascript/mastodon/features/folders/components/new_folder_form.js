import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { changeFolderEditorName, submitFolderEditor, resetFolderEditor } from '../../../actions/folders';
import IconButton from '../../../components/icon_button';
import { defineMessages, injectIntl } from 'react-intl';

const messages = defineMessages({
  label: { id: 'folders.new.name_placeholder', defaultMessage: 'New folder name' },
  name: { id: 'folders.new.create', defaultMessage: 'Add folder' },
});

const mapStateToProps = state => ({
  value: state.getIn(['folderEditor', 'name']),
  disabled: state.getIn(['folderEditor', 'isSubmitting']),
});

const mapDispatchToProps = dispatch => ({
  onInitialize: () => dispatch(resetFolderEditor()),
  onChange: value => dispatch(changeFolderEditorName(value)),
  onSubmit: () => dispatch(submitFolderEditor(true)),
});

@connect(mapStateToProps, mapDispatchToProps)
@injectIntl
export default class NewFolderForm extends React.PureComponent {

  static propTypes = {
    value: PropTypes.string.isRequired,
    disabled: PropTypes.bool,
    intl: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onSubmit: PropTypes.func.isRequired,
  };

  handleChange = e => {
    this.props.onChange(e.target.value);
  }

  handleSubmit = e => {
    e.preventDefault();
    this.props.onSubmit();
  }

  handleClick = () => {
    this.props.onSubmit();
  }

  render () {
    const { value, disabled, intl } = this.props;

    const label = intl.formatMessage(messages.label);
    const name = intl.formatMessage(messages.name);

    return (
      <form className='column-inline-form' onSubmit={this.handleSubmit}>
        <label>
          <span style={{ display: 'none' }}>{label}</span>

          <input
            className='setting-text'
            value={value}
            disabled={disabled}
            onChange={this.handleChange}
            placeholder={label}
          />
        </label>

        <IconButton
          disabled={disabled}
          icon='plus'
          title={name}
          onClick={this.handleClick}
        />
      </form>
    );
  }

}
